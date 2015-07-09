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
require "azure/table/table_service"
require "azure/core/http/http_error"

describe Azure::Table::TableService do
  describe "#insert_or_replace_entity" do
    subject { Azure::Table::TableService.new }
    let(:table_name){ TableNameHelper.name }

    let(:entity_properties) {
      { 
        "PartitionKey" => "testingpartition",
        "CustomStringProperty" => "CustomPropertyValue",
        "CustomIntegerProperty" => 37,
        "CustomBooleanProperty" => true,
        "CustomDateProperty" => Time.now
      }
    }

    before { 
      subject.create_table table_name
    }

    after { TableNameHelper.clean }

    it "creates an entity if it does not already exist" do 
      entity = entity_properties.dup
      entity["RowKey"] = "abcd1234"

      does_not_exist = true
      begin
        subject.get_entity table_name, entity["PartitionKey"], entity["RowKey"]
        does_not_exist = false
      rescue
      end

      expect(does_not_exist).to be_truthy

      etag = subject.insert_or_replace_entity table_name, entity
      expect(etag).to be_a_kind_of(String)

      result = subject.get_entity table_name, entity["PartitionKey"], entity["RowKey"]

      expect(result).to be_a_kind_of(Azure::Table::Entity)
      expect(result.table).to eq(table_name)
      expect(result.etag).to eq(etag)
      
      entity.each { |k,v|
        unless entity[k].class == Time
          expect(result.properties[k]).to eq(entity[k])
        else
          expect(result.properties[k].to_i).to eq(entity[k].to_i)
        end
      }
    end

    it "updates an existing entity, removing any properties not included in the update operation" do 
      entity = entity_properties.dup
      entity["RowKey"] = "abcd1234_existing"

      result = subject.insert_entity table_name, entity

      existing_etag = ""

      exists = false
      begin
        existing = subject.get_entity table_name, entity["PartitionKey"], entity["RowKey"]
        existing_etag = existing.etag
        exists = true
      rescue
      end

      expect(exists).to be_truthy "cannot verify existing record"

      etag = subject.insert_or_replace_entity table_name, { 
        "PartitionKey" => entity["PartitionKey"],
        "RowKey" => entity["RowKey"],
        "NewCustomProperty" => "NewCustomValue"
      }

      expect(etag).to be_a_kind_of(String)
      expect(etag).not_to eq(existing_etag)

      result = subject.get_entity table_name, entity["PartitionKey"], entity["RowKey"]
      
      expect(result).to be_a_kind_of(Azure::Table::Entity)
      expect(result.table).to eq(table_name)

      # removed all existing props
      entity.each { |k,v|
        expect(result.properties).not_to include(k) unless k == "PartitionKey" || k == "RowKey"
      }

      # and has the new one
      expect(result.properties["NewCustomProperty"]).to eq("NewCustomValue")
    end

    it "errors on an invalid table name" do
      expect { entity = entity_properties.dup
        entity["RowKey"] = "row_key"
        subject.insert_or_replace_entity "this_table.cannot-exist!", entity
       }.to raise_error(Azure::Core::Http::HTTPError)
    end

    it "errors on an invalid partition key" do
      expect { entity = entity_properties.dup
        entity["PartitionKey"] = "this/partition_key#is?invalid"
        entity["RowKey"] = "row_key"
        subject.insert_or_replace_entity table_name, entity
       }.to raise_error(Azure::Core::Http::HTTPError)
    end

    it "errors on an invalid row key" do
      expect { entity = entity_properties.dup
        entity["RowKey"] = "this/partition_key#is?invalid"
        subject.insert_or_replace_entity table_name, entity
       }.to raise_error(Azure::Core::Http::HTTPError)
    end
  end
end