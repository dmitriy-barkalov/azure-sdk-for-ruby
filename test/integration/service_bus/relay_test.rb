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

describe "ServiceBus Relay" do

  subject { Azure::ServiceBus::ServiceBusService.new }
  let(:bus_name) { ServiceBusRelayNameHelper.name }
  let(:name_alternative) { ServiceBusRelayNameHelper.name }
  let(:description) {{
    :relay_type => 'Http',
    :requires_client_authorization => true,
    :requires_transport_security => true
  }}
  let(:description_alternative) {{
    :relay_type => 'NetTcp',
    :requires_client_authorization => false,
    :requires_transport_security => false
  }}

  after { ServiceBusRelayNameHelper.clean }

  it "should be able to create a new relay endpoint from a string and description Hash" do
    relay = subject.create_relay name_alternative, description_alternative
    expect(relay).to be_a_kind_of(Azure::ServiceBus::Relay)
    expect(relay.name).to eq(name_alternative)

    expect(relay.relay_type).to eq(description_alternative[:relay_type])
    expect(relay.requires_client_authorization).to eq(description_alternative[:requires_client_authorization])
    expect(relay.requires_transport_security).to eq(description_alternative[:requires_transport_security])
  end

  it "should be able to create a new relay from a Relay with a description Hash" do
    relay = subject.create_relay Azure::ServiceBus::Relay.new(name_alternative, description_alternative)
    expect(relay).to be_a_kind_of(Azure::ServiceBus::Relay)
    expect(relay.name).to eq(name_alternative)

    expect(relay.relay_type).to eq(description_alternative[:relay_type])
    expect(relay.requires_client_authorization).to eq(description_alternative[:requires_client_authorization])
    expect(relay.requires_transport_security).to eq(description_alternative[:requires_transport_security])
  end

  describe 'when a relay exists' do
    before { subject.create_relay bus_name, description }

    describe "#get_relay" do
      it "should be able to get a relay by name" do
        result = subject.get_relay bus_name

        expect(result).to be_a_kind_of(Azure::ServiceBus::Relay)
        expect(result.name).to eq(bus_name)
      end

      it "if the relay endpoint doesn't exists it should throw" do
        expect { subject.get_relay ServiceBusRelayNameHelper.name }.to raise_error(Azure::Core::Http::HTTPError)
      end
    end

    describe '#delete_relay' do
      it "should raise exception if the relay endpoint cannot be deleted" do
        expect { subject.delete_relay ServiceBusRelayNameHelper.name }.to raise_error(Azure::Core::Http::HTTPError)
      end

      it "should be able to delete the relay endpoint" do
        response = subject.delete_relay bus_name
        expect(response).to eq(nil)
      end
    end

    describe 'when there are multiple relay endpoints' do
      let(:name1) { ServiceBusRelayNameHelper.name }
      let(:name2) { ServiceBusRelayNameHelper.name }
      before { 
        subject.create_relay name1, description
        subject.create_relay name2, description_alternative
      }
      
      it "should be able to get a list of relays" do
        result = subject.list_relays

        expect(result).to be_a_kind_of(Array)
        q_found = false
        q1_found = false
        q2_found = false
        result.each { |q|
          q_found = true if q.name == bus_name
          q1_found = true if q.name == name1
          q2_found = true if q.name == name2
        }
        expect((q_found and q1_found and q2_found)).to be_truthy "list_relays did not return expected relay endpoints"
      end

      it "should be able to use $skip token with list_relays" do
        result = subject.list_relays
        result2 = subject.list_relays({ :skip => 1 })
        expect(result2.length).to eq(result.length - 1)
        expect(result2[0].id).to eq(result[1].id)
      end
      
      it "should be able to use $top token with list_relays" do
        result = subject.list_relays
        expect(result.length).not_to eq(1)

        result2 = subject.list_relays({ :top => 1 })
        expect(result2.length).to eq(1)
      end

      it "should be able to use $skip and $top token together with list_relays" do
        result = subject.list_relays
        result2 = subject.list_relays({ :skip => 1, :top => 1 })
        expect(result2.length).to eq(1)
        expect(result2[0].id).to eq(result[1].id)
      end
    end
  end
end