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
  describe "#delete_table" do
    subject { Azure::Table::TableService.new }
    let(:table_name){ TableNameHelper.name }
    before { subject.create_table table_name }
    after { TableNameHelper.clean }

    it "deletes a table and returns nil on success" do
      result = subject.delete_table(table_name)
      expect(result).to be_nil
      
      tables = subject.query_tables
      expect(tables).not_to include(table_name)
    end

    it "errors on an invalid table" do
      expect { subject.delete_table "this_table.cannot-exist!" }.to raise_error(Azure::Core::Http::HTTPError)
    end
  end
end