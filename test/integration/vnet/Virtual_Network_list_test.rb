#-------------------------------------------------------------------------
# Copyright 2013 Microsoft Open Technologies, Inc.
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

describe Azure::VirtualNetworkManagement::VirtualNetwork do

  subject { Azure::VirtualNetworkManagementService.new }

  let(:affinity_group_name) { 'my-affinity-group' }
  let(:geo_location) { 'West US' }
  let(:vnet_name) { 'vnet-integration-test' }

  before do
    address_space = %w(172.16.0.0/12 10.0.0.0/8 192.168.0.0/24)
    unless subject.list_virtual_networks.map(&:name).include?(vnet_name)
      subject.set_network_configuration(
        vnet_name,
        geo_location,
        address_space
      )
    end
  end

  describe '#list_virtual_networks' do
    it 'Gets a list of virtual networks for the current subscription.' do
      virtual_networks = subject.list_virtual_networks
      expect(virtual_networks).not_to be_nil
      expect(virtual_networks).to be_a_kind_of(Array)
      expect(virtual_networks.first).to be_a_kind_of(Azure::VirtualNetworkManagement::VirtualNetwork)
      expect(virtual_networks.size).to be >= 1
    end
  end
end
