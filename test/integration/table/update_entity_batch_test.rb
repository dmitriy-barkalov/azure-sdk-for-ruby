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
  describe "#update_entity_batch" do
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

    it "updates an existing entity, removing any properties not included in the update operation" do 
      batch = Azure::Table::Batch.new table_name, entity_properties["PartitionKey"]
      batch.update entity_properties["RowKey"], {
        "PartitionKey" => entity_properties["PartitionKey"],
        "RowKey" => entity_properties["RowKey"],
        "NewCustomProperty" => "NewCustomValue"
      }
      etags = subject.execute_batch batch

      # etag for first (and only) operation
      expect(etags[0]).to be_a_kind_of(String)
      expect(etags[0]).not_to eq(@existing_etag)

      result = subject.get_entity table_name, entity_properties["PartitionKey"], entity_properties["RowKey"]
      
      expect(result).to be_a_kind_of(Azure::Table::Entity)
      expect(result.table).to eq(table_name)

      # removed all existing props
      entity_properties.each { |k,v|
        expect(result.properties).not_to include(k) unless k == "PartitionKey" || k == "RowKey"
      }

      # and has the new one
      expect(result.properties["NewCustomProperty"]).to eq("NewCustomValue")
    end

    it "updates an existing entity, removing any properties not included in the update operation and adding nil one" do 
      batch = Azure::Table::Batch.new table_name, entity_properties["PartitionKey"]
      batch.update entity_properties["RowKey"], {
        "PartitionKey" => entity_properties["PartitionKey"],
        "RowKey" => entity_properties["RowKey"],
        "NewCustomProperty" => nil
      }
      etags = subject.execute_batch batch

      # etag for first (and only) operation
      expect(etags[0]).to be_a_kind_of(String)
      expect(etags[0]).not_to eq(@existing_etag)

      result = subject.get_entity table_name, entity_properties["PartitionKey"], entity_properties["RowKey"]
      
      expect(result).to be_a_kind_of(Azure::Table::Entity)
      expect(result.table).to eq(table_name)

      # removed all existing props
      entity_properties.each { |k,v|
        expect(result.properties).not_to include(k) unless k == "PartitionKey" || k == "RowKey"
      }

      # and has the new one
      expect(result.properties["NewCustomProperty"]).to eq(nil)
    end

    it "errors on a non-existing row key" do
      expect { entity = entity_properties.dup
        entity["RowKey"] = "this-row-key-does-not-exist"

        batch = Azure::Table::Batch.new table_name, entity["PartitionKey"]
        batch.update entity["RowKey"], entity
        etags = subject.execute_batch batch
       }.to raise_error(Azure::Core::Http::HTTPError)
    end

    it "errors on an invalid table name" do
      expect { batch = Azure::Table::Batch.new "this_table.cannot-exist!", entity_properties["PartitionKey"]
        batch.update entity_properties["RowKey"], entity_properties
        etags = subject.execute_batch batch
       }.to raise_error(Azure::Core::Http::HTTPError)
    end

    it "errors on an invalid partition key" do
      expect { entity = entity_properties.dup
        entity["PartitionKey"] = "this/partition_key#is?invalid"

        batch = Azure::Table::Batch.new table_name, entity["PartitionKey"]
        batch.update entity["RowKey"], entity
        etags = subject.execute_batch batch
       }.to raise_error(Azure::Core::Http::HTTPError)
    end

    it "errors on an invalid row key" do
      expect { entity = entity_properties.dup
        entity["RowKey"] = "this/row_key#is?invalid"

        batch = Azure::Table::Batch.new table_name, entity["PartitionKey"]
        batch.update entity["RowKey"], entity
        etags = subject.execute_batch batch
       }.to raise_error(Azure::Core::Http::HTTPError)
    end
  end
end