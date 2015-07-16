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

describe 'ServiceBus Topics' do
  subject { Azure::ServiceBus::ServiceBusService.new }
  after { ServiceBusTopicNameHelper.clean }
  let(:topic){ ServiceBusTopicNameHelper.name }
  let(:topic_alternative){ ServiceBusTopicNameHelper.name }
  let(:description_alternative) {{
    :default_message_time_to_live => 'PT30M',
    :maximum_number_of_subscriptions => 3,
    :max_size_in_megabytes => 2048,
    :requires_duplicate_detection => true,
    :dead_lettering_on_filter_evaluation_exceptions => true,
    :duplicate_detection_history_time_window => 'PT20M',
    :enable_batched_operations => true,
  }}

  it 'should be able to create a new topic' do
    result = subject.create_topic topic, { :max_size_in_megabytes => 2048 }
    expect(result).to be_a_kind_of(Azure::ServiceBus::Topic)
    expect(result.name).to eq(topic)
    expect(result.max_size_in_megabytes).to eq(2048)
  end

  it 'should be able to create a new topic from a string and description Hash' do
    result = subject.create_topic topic_alternative, description_alternative
    expect(result).to be_a_kind_of(Azure::ServiceBus::Topic)
    expect(result.name).to eq(topic_alternative)

    expect(result.default_message_time_to_live).to eq(1800.0)
    #expect(result.maximum_number_of_subscriptions).to eq(description_alternative[:maximum_number_of_subscriptions])
    expect(result.max_size_in_megabytes).to eq(description_alternative[:max_size_in_megabytes])
    expect(result.requires_duplicate_detection).to eq(description_alternative[:requires_duplicate_detection])
    expect(result.dead_lettering_on_filter_evaluation_exceptions).to eq(description_alternative[:dead_lettering_on_filter_evaluation_exceptions])
    expect(result.duplicate_detection_history_time_window).to eq(1200.0)
    expect(result.enable_batched_operations).to eq(description_alternative[:enable_batched_operations])
  end

  describe 'when a topic exists' do
    before { subject.create_topic topic }

    it 'should be able to delete the topic' do
      subject.delete_topic topic
    end

    it 'should be able to get the topic' do
      result = subject.get_topic topic
      expect(result).to be_a_kind_of(Azure::ServiceBus::Topic)
      expect(result.name).to eq(topic)
    end

    it 'should be able to list topics' do
      result = subject.list_topics
      topic_found = false
      result.each { |t|
        topic_found = true if t.name == topic
      }
      expect(topic_found).to be_truthy "list_topics didn't include the expected topic"
    end

    it 'should be able to send the topic a message' do
      message = Azure::ServiceBus::BrokeredMessage.new('some text', {:prop1 => 'val1'}) do |m|
        m.to = 'me'
        m.label = 'my_label'
      end
      result = subject.send_topic_message topic, message
      expect(result).to be_nil
    end

    describe 'when there are multiple topics' do
      let(:topic1) { ServiceBusTopicNameHelper.name }
      let(:topic2) { ServiceBusTopicNameHelper.name }

      before { 
        subject.create_topic topic1
        subject.create_topic topic2
      }

      it 'should be able to list topics' do
        result = subject.list_topics
        topic_found = false
        topic1_found = false
        topic2_found = false
        result.each { |t|
          topic_found = true if t.name == topic
          topic1_found = true if t.name == topic1
          topic2_found = true if t.name == topic2
        }
        expect((topic_found and topic1_found and topic2_found)).to be_truthy "list_topics didn't include the expected topic"
      end

      it 'should be able to use $skip token with list_topics' do
        result = subject.list_topics
        result2 = subject.list_topics({ :skip => 1 })
        expect(result2.length).to eq(result.length - 1)
        expect(result2[0].id).to eq(result[1].id)
      end
      
      it 'should be able to use $top token with list_topics' do
        result = subject.list_topics
        expect(result.length).not_to eq(1)

        result2 = subject.list_topics({ :top => 1 })
        expect(result2.length).to eq(1)
      end

      it 'should be able to use $skip and $top token together with list_topics' do
        result = subject.list_topics
        result2 = subject.list_topics({ :skip => 1, :top => 1 })
        expect(result2.length).to eq(1)
        expect(result2[0].id).to eq(result[1].id)
      end
    end
  end
end
