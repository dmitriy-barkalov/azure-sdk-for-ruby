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

describe 'ServiceBus Queues' do

  subject { Azure::ServiceBus::ServiceBusService.new }
  let(:queue_name) { ServiceBusQueueNameHelper.name }
  let(:name_alternative) { ServiceBusQueueNameHelper.name }
  let(:description) {{
    :default_message_time_to_live => 'P10675199DT2H48M5.4775807S',
    :duplicate_detection_history_time_window => 'PT10M',
    :dead_lettering_on_message_expiration => "false",
    :lock_duration => 'PT30S',
    :max_delivery_count => "10",
    :max_size_in_megabytes => "1",
    :requires_duplicate_detection => "true",
    :requires_session => "false"
  }}
  let(:description_alternative) {{
    :lock_duration => 'PT30S',
    :max_size_in_megabytes => 2048,
    :requires_duplicate_detection => true,
    :requires_session => true,
    :default_message_time_to_live => 'PT30M',
    :dead_lettering_on_message_expiration => true,
    :duplicate_detection_history_time_window => 'PT20M',
    :max_delivery_count => 20,
    :enable_batched_operations => true
  }}

  after { ServiceBusQueueNameHelper.clean }

  it "should be able to create a new queue from a string" do
    queue = subject.create_queue queue_name
    expect(queue).to be_a_kind_of(Azure::ServiceBus::Queue)
    expect(queue.name).to eq(queue_name)
  end

  it "should be able to create a new queue from a Queue" do
    queue = subject.create_queue Azure::ServiceBus::Queue.new(queue_name)
    expect(queue).to be_a_kind_of(Azure::ServiceBus::Queue)
    expect(queue.name).to eq(queue_name)
  end

  it "should be able to create a new queue from a string and description Hash" do
    queue = subject.create_queue name_alternative, description_alternative
    expect(queue).to be_a_kind_of(Azure::ServiceBus::Queue)
    expect(queue.name).to eq(name_alternative)

    expect(queue.lock_duration).to eq(30.0)
    expect(queue.max_size_in_megabytes).to eq(description_alternative[:max_size_in_megabytes])
    expect(queue.requires_duplicate_detection).to eq(description_alternative[:requires_duplicate_detection])
    expect(queue.requires_session).to eq(description_alternative[:requires_session])
    expect(queue.default_message_time_to_live).to eq(1800.0)
    expect(queue.dead_lettering_on_message_expiration).to eq(description_alternative[:dead_lettering_on_message_expiration])
    expect(queue.duplicate_detection_history_time_window).to eq(1200.0)
    expect(queue.max_delivery_count).to eq(description_alternative[:max_delivery_count])
    expect(queue.enable_batched_operations).to eq(description_alternative[:enable_batched_operations])
  end

  it "should be able to create a new queue from a Queue with a description Hash" do
    queue = subject.create_queue Azure::ServiceBus::Queue.new(name_alternative, description_alternative)
    expect(queue).to be_a_kind_of(Azure::ServiceBus::Queue)
    expect(queue.name).to eq(name_alternative)

    expect(queue.lock_duration).to eq(30.0)
    expect(queue.max_size_in_megabytes).to eq(description_alternative[:max_size_in_megabytes])
    expect(queue.requires_duplicate_detection).to eq(description_alternative[:requires_duplicate_detection])
    expect(queue.requires_session).to eq(description_alternative[:requires_session])
    expect(queue.default_message_time_to_live).to eq(1800.0)
    expect(queue.dead_lettering_on_message_expiration).to eq(description_alternative[:dead_lettering_on_message_expiration])
    expect(queue.duplicate_detection_history_time_window).to eq(1200.0)
    expect(queue.max_delivery_count).to eq(description_alternative[:max_delivery_count])
    expect(queue.enable_batched_operations).to eq(description_alternative[:enable_batched_operations])
  end

  describe 'when a queue exists' do
    before { subject.create_queue queue_name }

    describe '#delete_queue' do
      it "should raise exception if the queue cannot be deleted" do
        expect { subject.delete_queue ServiceBusQueueNameHelper.name }.to raise_error(Azure::Core::Http::HTTPError)
      end

      it "should be able to delete the queue" do
        response = subject.delete_queue queue_name
        expect(response).to eq(nil)
      end
    end

    describe "#get_queue" do
      it "should be able to get a queue by name" do
        result = subject.get_queue queue_name

        expect(result).to be_a_kind_of(Azure::ServiceBus::Queue)
        expect(result.name).to eq(queue_name)
      end

      it "if the queue doesn't exists it should throw" do
        expect { subject.get_queue ServiceBusQueueNameHelper.name }.to raise_error(Azure::Core::Http::HTTPError)
      end
    end

    describe 'when there are multiple queues' do
      let(:name1) { ServiceBusQueueNameHelper.name }
      let(:name2) { ServiceBusQueueNameHelper.name }
      before { 
        subject.create_queue name1
        subject.create_queue name2
      }
      
      it "should be able to get a list of queues" do
        result = subject.list_queues

        expect(result).to be_a_kind_of(Array)
        q_found = false
        q1_found = false
        q2_found = false
        result.each { |q|
          q_found = true if q.name == queue_name
          q1_found = true if q.name == name1
          q2_found = true if q.name == name2
        }
        expect((q_found and q1_found and q2_found)).to be_truthy "list_queues did not return expected queues"
      end

      it "should be able to use $skip token with list_queues" do
        result = subject.list_queues
        result2 = subject.list_queues({ :skip => 1 })
        expect(result2.length).to eq(result.length - 1)
        expect(result2[0].id).to eq(result[1].id)
      end
      
      it "should be able to use $top token with list_queues" do
        result = subject.list_queues
        expect(result.length).not_to eq(1)

        result2 = subject.list_queues({ :top => 1 })
        expect(result2.length).to eq(1)
      end

      it "should be able to use $skip and $top token together with list_queues" do
        result = subject.list_queues
        result2 = subject.list_queues({ :skip => 1, :top => 1 })
        expect(result2.length).to eq(1)
        expect(result2[0].id).to eq(result[1].id)
      end
    end

    it "should be able to send a message to a queue" do
      msg = Azure::ServiceBus::BrokeredMessage.new("some text") do |m|
        m.to = "yo"
      end
      res = subject.send_queue_message queue_name, msg
      expect(res).to be_nil
    end

    describe "when the queue has messages" do
      let(:messageContent) { 'messagecontent' }
      let(:to) { 'yo' }
      let(:label) { 'my_label' }
      let(:properties) {{
        "CustomDoubleProperty" => 3.141592,
        "CustomInt32Property" => 37,
        "CustomInt64Property" => 2**32,
        "CustomInt64NegProperty" => -(2**32),
        "CustomStringProperty" => "CustomPropertyValue",
        "CustomDateProperty" => Time.now,
        "CustomTrueProperty" => true,
        "CustomFalseProperty" => false,
        "CustomNilProperty" => nil,
        "CustomJSONProperty" => "testingpa\n\"{}\\rtition"
      }}
      let(:msg) { m = Azure::ServiceBus::BrokeredMessage.new(messageContent, properties); m.to = 'me'; m }
      
      before { subject.send_queue_message queue_name, msg }
      
      it "should be able to peek a message from a queue" do
        retrieved = subject.peek_lock_queue_message queue_name
        expect(retrieved).to be_a_kind_of(Azure::ServiceBus::BrokeredMessage)

        expect(retrieved.body).to eq(msg.body)
        expect(retrieved.to).to eq(msg.to)
        expect(retrieved.label).to eq(msg.label)

        properties.each { |k,v|
          unless properties[k].class == Time
            expect(retrieved.properties[k.downcase]).to eq(properties[k])
          else
            # Time comes back as string as there is no good way to distinguish
            expect(retrieved.properties[k.downcase].to_s).to eq(properties[k].httpdate)
          end
        }

        refute retrieved.lock_token.nil?
        refute retrieved.sequence_number.nil?
      end

      it "should be able to read-delete a message from a queue" do
        retrieved = subject.read_delete_queue_message queue_name

        expect(retrieved).to be_a_kind_of(Azure::ServiceBus::BrokeredMessage)
        expect(retrieved.body).to eq(msg.body)
        expect(retrieved.to).to eq(msg.to)

        # it should be deleted
        retrieved = subject.read_delete_queue_message queue_name, { :timeout => 2 }
        expect(retrieved).to be_nil
      end

      it "should be able to unlock a message from a queue" do
        retrieved = subject.peek_lock_queue_message queue_name, { :timeout => 2 }

        # There shouldn't be an available message in the queue
        retrieved2 = subject.peek_lock_queue_message queue_name, { :timeout => 2 }
        expect(retrieved2).to be_nil

        # Unlock the message
        res = subject.unlock_queue_message retrieved
        expect(res).to be_nil

        # The message should be available once again
        retrieved = subject.peek_lock_queue_message queue_name, { :timeout => 2 }
        expect(retrieved.body).to eq(msg.body)
      end
    
      it "should be able to delete a message from a queue" do

        retrieved = subject.peek_lock_queue_message queue_name
        expect(retrieved.body).to eq(msg.body)

        subject.delete_queue_message retrieved

        # it should be deleted
        retrieved = subject.peek_lock_queue_message queue_name, { :timeout => 2 }
        expect(retrieved).to be_nil
      end

      it "should be able to read a message from a queue" do
        subject.send_queue_message queue_name, msg
        retrieved = subject.receive_queue_message queue_name

        expect(retrieved).to be_a_kind_of(Azure::ServiceBus::BrokeredMessage)
        expect(retrieved.body).to eq(msg.body)
        expect(retrieved.to).to eq(msg.to)
      end
    end
  end
end