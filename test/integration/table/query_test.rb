#-------------------------------------------------------------------------
# # Copyright (c) Microsoft and contributors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#--------------------------------------------------------------------------
require_relative '../test_helper'


describe Azure::Table::TableService do
  describe "#query_entities" do
    subject { Azure::Table::TableService.new }
    let(:table_name){ TableNameHelper.name }
    let(:entities_per_partition){3}
    let(:partitions){ ["part1", "part2", "part3"]}
    let(:entities){ 
      entities = {}
      index = 0
      partitions.each { |p|
        entities[p] = []
        (0..entities_per_partition).each { |i|
          entities[p].push "entity-#{index}"
          index+=1
        }
      }
      entities
    }
    let(:entity_properties){ 
      { 
        "CustomStringProperty" => "CustomPropertyValue",
        "CustomIntegerProperty" => 37,
        "CustomBooleanProperty" => true,
        "CustomDateProperty" => Time.now
      }
    }
    before { 
      subject.create_table table_name
      partitions.each { |p|
        entities[p].each { |e| 
          entity = entity_properties.dup
          entity[:PartitionKey] = p
          entity[:RowKey] = e
          subject.insert_entity table_name, entity
        }
      }
    }

    after { TableNameHelper.clean }

    it "Queries a table for list of entities" do
      q = Azure::Table::Query.new.from table_name

      result = q.execute
      expect(result).to be_a_kind_of(Array)
      expect(result.length).to eq(((partitions.length + 1) * entities_per_partition))

      result.each { |e|
        expect(entities[e.properties["PartitionKey"]]).to include(e.properties["RowKey"])
        entity_properties.each { |k,v|
          unless v.class == Time
            expect(e.properties[k]).to eq(v)
          else
            expect(e.properties[k].to_i).to eq(v.to_i)
          end
        }
      }
    end

    it "can constrain by partition and row key, returning zero or one entity" do
      partition = partitions[0]
      row_key = entities[partition][0]

      q = Azure::Table::Query.new
        .from(table_name)
        .partition(partition)
        .row(row_key)

      result = q.execute
      expect(result).to be_a_kind_of(Array)
      expect(result.length).to eq(1)

      result.each { |e|
        expect(e.properties["RowKey"]).to eq(row_key)
        entity_properties.each { |k,v|
          unless v.class == Time
            expect(e.properties[k]).to eq(v)
          else
            expect(e.properties[k].to_i).to eq(v.to_i)
          end
        }
      }
    end

    it "can project a subset of properties, populating sparse properties with nil" do
      projection = ['CustomIntegerProperty', 'ThisPropertyDoesNotExist']

      q = Azure::Table::Query.new
        .from(table_name)
        .select(projection[0])
        .select(projection[1])

      result = q.execute
      expect(result).to be_a_kind_of(Array)
      expect(result.length).to eq(((partitions.length + 1) * entities_per_partition))

      result.each { |e|
        expect(e.properties.length).to eq(projection.length)
        expect(e.properties["CustomIntegerProperty"]).to eq(entity_properties["CustomIntegerProperty"])
        expect(e.properties).to include("ThisPropertyDoesNotExist")
        expect(e.properties["ThisPropertyDoesNotExist"]).to eq("")
      }
    end

    it "can filter by one or more properties, returning a matching set of entities" do
      subject.insert_entity table_name, entity_properties.merge({ 
        "PartitionKey" => "filter-test-partition",
        "RowKey" => "filter-test-key",
        "CustomIntegerProperty" => entity_properties["CustomIntegerProperty"] + 1,
        "CustomBooleanProperty"=> false
      })

      q = Azure::Table::Query.new
        .from(table_name)
        .where("CustomIntegerProperty gt #{entity_properties['CustomIntegerProperty']}")
        .where("CustomBooleanProperty eq false")

      result = q.execute
      expect(result).to be_a_kind_of(Array)
      expect(result.length).to eq(1)
      expect(result.first.properties["PartitionKey"]).to eq("filter-test-partition")

      q = Azure::Table::Query.new
        .from(table_name)
        .where("CustomIntegerProperty gt #{entity_properties['CustomIntegerProperty']}")
        .where("CustomBooleanProperty eq true")
      result = q.execute
      expect(result).to be_a_kind_of(Array)
      expect(result.length).to eq(0)
    end

    it "can limit the result set using the top parameter" do
      q = Azure::Table::Query.new
        .from(table_name)
        .top(3)

      result = q.execute
      expect(result).to be_a_kind_of(Array)
      expect(result.length).to eq(3)
      expect(result.continuation_token).not_to be_nil
    end

    it "can page results using the top parameter and continuation_token" do
      q = Azure::Table::Query.new
        .from(table_name)
        .top(3)

      result = q.execute
      expect(result).to be_a_kind_of(Array)
      expect(result.length).to eq(3)
      expect(result.continuation_token).not_to be_nil

      q = Azure::Table::Query.new
        .from(table_name)
        .top(3)
        .next_row(result.continuation_token[:next_row_key])
        .next_partition(result.continuation_token[:next_partition_key])

      result2 = q.execute
      expect(result2).to be_a_kind_of(Array)
      expect(result2.length).to eq(3)
      expect(result2.continuation_token).not_to be_nil

      q = Azure::Table::Query.new
        .from(table_name)
        .top(3)
        .next_row(result2.continuation_token[:next_row_key])
        .next_partition(result2.continuation_token[:next_partition_key])

      result3 = q.execute
      expect(result3).to be_a_kind_of(Array)
      expect(result3.length).to eq(3)
      expect(result3.continuation_token).not_to be_nil

      q = Azure::Table::Query.new
        .from(table_name)
        .top(3)
        .next_row(result3.continuation_token[:next_row_key])
        .next_partition(result3.continuation_token[:next_partition_key])

      result4 = q.execute
      expect(result4).to be_a_kind_of(Array)
      expect(result4.length).to eq(3)
      expect(result4.continuation_token).to be_nil
    end

    it "can combine projection, filtering, and paging in the same query" do
      subject.insert_entity table_name, entity_properties.merge({
        "PartitionKey" => "filter-test-partition",
        "RowKey" => "filter-test-key",
        "CustomIntegerProperty" => entity_properties["CustomIntegerProperty"] + 1,
        "CustomBooleanProperty"=> false
      })


      q = Azure::Table::Query.new
        .from(table_name)
        .select("PartitionKey")
        .select("CustomIntegerProperty")
        .where("CustomIntegerProperty eq #{entity_properties['CustomIntegerProperty']}")
        .top(3)

      result = q.execute
      expect(result).to be_a_kind_of(Array)
      expect(result.length).to eq(3)
      expect(result.continuation_token).not_to be_nil

      expect(result.first.properties["CustomIntegerProperty"]).to eq(entity_properties["CustomIntegerProperty"])
      expect(result.first.properties["PartitionKey"]).not_to be_nil
      expect(result.first.properties.length).to eq(2)

      q.next_row(result.continuation_token[:next_row_key]).next_partition(result.continuation_token[:next_partition_key])

      result2 = q.execute
      expect(result2).to be_a_kind_of(Array)
      expect(result2.length).to eq(3)
      expect(result2.continuation_token).not_to be_nil

      q.next_row(result2.continuation_token[:next_row_key]).next_partition(result2.continuation_token[:next_partition_key])
      result3 = q.execute
      expect(result3).to be_a_kind_of(Array)
      expect(result3.length).to eq(3)
      expect(result3.continuation_token).not_to be_nil

      q.next_row(result3.continuation_token[:next_row_key]).next_partition(result3.continuation_token[:next_partition_key])
      result4 = q.execute
      expect(result4).to be_a_kind_of(Array)
      expect(result4.length).to eq(3)
      expect(result4.continuation_token).to be_nil
    end
  end
end