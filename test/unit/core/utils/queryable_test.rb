#-------------------------------------------------------------------------
# Copyright 2012 Microsoft Corporation
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
require 'test_helper'
require 'azure/core/utils/queryable'

describe Azure::Core::Utils::Queryable do

  include Azure::Core::Utils::Queryable

  describe "Translating a hash of options" do
    it "accept :skip" do
      opts = { :skip => 2 }
      translate_options_hash(opts).must_equal({ '$skip' => 2 })
    end

    it "accept :top" do
      opts = { :top => 3 }
      translate_options_hash(opts).must_equal({ '$top' => 3 })
    end
  end

  describe "Building query strings" do
    it "should build an empty string" do
      query = {}
      build_query(query).must_equal nil
    end

    it "should accept :select" do
      query = {
        :select => ["FirstName", "Email"]
      }
      build_query(query).must_equal "$select=FirstName,Email"
    end

    it "should accept :top" do
      query = {
        :top => 5
      }
      build_query(query).must_equal "$top=5"
    end

    it "should accept :filter" do
      query = {
        :filter => "FirstName eq 'Alfred'"
      }
      build_query(query).must_equal "$filter=FirstName%20eq%20'Alfred'"
    end

    it "should accept NextTableName" do
      query = {
        "NextTableName" => "my_table"
      }
      build_query(query).must_equal "NextTableName=my_table"
    end

    it "should accept NextPartitionKey and NextRowKey" do
      query = {
        "NextPartitionKey" => "part1",
        "NextRowKey" => "row1",
      }
      build_query(query).must_equal "NextPartitionKey=part1&NextRowKey=row1"
    end

    it "should accept :skip" do
      query = {
        :skip => 2
      }
      build_query(query).must_equal "$skip=2"
    end
  end
end
