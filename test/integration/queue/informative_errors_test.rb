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

describe Azure::Queue::QueueService do
  subject { Azure::Queue::QueueService.new }
  
  describe '#informative_errors_queue' do
    let(:queue_name){ QueueNameHelper.name }
    after { QueueNameHelper.clean }

    it "exception message should be valid" do
      # getting metadata from a non existent should throw
      begin 
        subject.get_queue_metadata queue_name
        flunk "No exception"
      rescue Azure::Core::Http::HTTPError => error
        expect(error.status_code).to eq(404)
        expect(error.type).to eq("QueueNotFound")
        expect(error.description.start_with?("The specified queue does not exist.")).to eq(true)
      end
    end
  end
end