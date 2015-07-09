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
require "azure/queue/queue_service"

describe Azure::Queue::QueueService do
  subject { Azure::Queue::QueueService.new }
  
  describe '#delete_queue' do
    let(:queue_name){ QueueNameHelper.name }
    before { subject.create_queue queue_name }
    after { QueueNameHelper.clean }

    it "deletes a queue and returns nil on success" do
      result = subject.delete_queue(queue_name)
      expect(result).to be_nil
      result = subject.list_queues
      result.each { |q| expect(q.name).not_to eq(queue_name) }
    end

    it "errors on an non-existent queue" do
      expect { subject.delete_queue QueueNameHelper.name }.to raise_error(Azure::Core::Http::HTTPError)
    end

    it "errors on an invalid queue" do
      expect { subject.delete_queue "this_queue.cannot-exist!" }.to raise_error(Azure::Core::Http::HTTPError)
    end
  end
end
