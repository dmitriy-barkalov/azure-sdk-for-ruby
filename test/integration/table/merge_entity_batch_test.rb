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

require "integration/test_helper"
require "azure/table/batch"
require "azure/table/table_service"
require "azure/core/http/http_error"

describe Azure::Table::TableService do
  describe "#merge_entity_batch" do
    subject { Azure::Table::TableService.new }
    let(:table_name){ TableNameHelper.name }

    let(:entity_properties){
      {
        "PartitionKey" => "testingpartition",
        "RowKey" => "abcd1234_existing",
        "CustomStringProperty" => "CustomPropertyValue",
        "CustomIntegerProperty" => 37,
        "CustomBooleanProperty" => true,
        "CustomDateProperty" => Time.now
      }
    }

    before {
      subject.create_table table_name
      subject.insert_entity table_name, entity_properties
      @existing_etag = ""

      exists = false
      begin
        existing = subject.get_entity table_name, entity_properties["PartitionKey"], entity_properties["RowKey"]
        @existing_etag = existing.etag
        exists = true
      rescue
      end

      expect(exists).to be_truthy "cannot verify existing record"
    }

    after { TableNameHelper.clean }

    it "updates an existing entity, merging the properties" do
      batch = Azure::Table::Batch.new table_name, entity_properties["PartitionKey"]
      batch.merge entity_properties["RowKey"], { 
        "PartitionKey" => entity_properties["PartitionKey"],
        "RowKey" => entity_properties["RowKey"],
        "NewCustomProperty" => "NewCustomValue"
      }
      etags = subject.execute_batch batch

      expect(etags[0]).to be_a_kind_of(String)
      expect(etags[0]).not_to eq(@existing_etag)

      result = subject.get_entity table_name, entity_properties["PartitionKey"], entity_properties["RowKey"]

      expect(result).to be_a_kind_of(Azure::Table::Entity)
      expect(result.table).to eq(table_name)
      expect(result.properties["PartitionKey"]).to eq(entity_properties["PartitionKey"])
      expect(result.properties["RowKey"]).to eq(entity_properties["RowKey"])

      # retained all existing props
      entity_properties.each { |k,v|
        unless entity_properties[k].class == Time
          expect(result.properties[k]).to eq(entity_properties[k])
        else
          expect(result.properties[k].to_i).to eq(entity_properties[k].to_i)
        end
      }

      # and has the new one
      expect(result.properties["NewCustomProperty"]).to eq("NewCustomValue")
    end

    it "errors on a non-existing row key" do
      expect { entity = entity_properties.dup
        entity["RowKey"] = "this-row-key-does-not-exist"

        batch = Azure::Table::Batch.new table_name, entity["PartitionKey"]
        batch.merge entity["RowKey"], entity
        etags = subject.execute_batch batch
       }.to raise_error(Azure::Core::Http::HTTPError)
    end

    it "errors on an invalid table name" do
      expect { batch = Azure::Table::Batch.new "this_table.cannot-exist!", entity_properties["PartitionKey"]
        batch.merge entity_properties["RowKey"], entity_properties
        etags = subject.execute_batch batch
       }.to raise_error(Azure::Core::Http::HTTPError)
    end

    it "errors on an invalid partition key" do
      expect { entity = entity_properties.dup
        entity["PartitionKey"] = "this/partition_key#is?invalid"

        batch = Azure::Table::Batch.new table_name, entity["PartitionKey"]
        batch.merge entity["RowKey"], entity
        etags = subject.execute_batch batch
       }.to raise_error(Azure::Core::Http::HTTPError)
    end

    it "errors on an invalid row key" do
      expect { entity = entity_properties.dup
        entity["RowKey"] = "this/row_key#is?invalid"

        batch = Azure::Table::Batch.new table_name, entity["PartitionKey"]
        batch.merge entity["RowKey"], entity
        etags = subject.execute_batch batch
       }.to raise_error(Azure::Core::Http::HTTPError)
    end
  end
end