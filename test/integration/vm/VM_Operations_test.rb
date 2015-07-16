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

describe Azure::VirtualMachineManagementService do
  let(:vm_name) { 'test-operation-vm' }
  let(:csn) { vm_name + '-service-qwert' }
  subject { Azure::VirtualMachineManagementService.new }

  before do
    params = {
      vm_name: vm_name,
      vm_user: 'user',
      image: LinuxImage.name,
      password: 'User123',
      location: LinuxImageLocation
    }
    options = {
      storage_account_name: StorageAccountName,
      cloud_service_name: csn,
    }
    vm = subject.get_virtual_machine(vm_name, csn)
    if vm.nil?
      subject.create_virtual_machine(params, options)
    end
  end

  describe 'Operations on virtual machine' do

    describe '#shutdown_virtual_machine' do
      it 'shuts down virtual machine' do
        subject.shutdown_virtual_machine(vm_name, csn)
        vm = subject.get_virtual_machine(vm_name, csn)
        expect(%w(StoppedVM StoppedDeallocated)).to include(vm.status)

        msg = subject.shutdown_virtual_machine(vm_name, csn)
        emsg = 'Cannot perform the shutdown operation on a stopped virtual machine'
        expect(msg).to match(/#{emsg}/)
      end

      it 'raises an error if virtual machine doesn\'t exists' do
        name = 'test-shutdown'
        msg = subject.shutdown_virtual_machine(name, csn)
        expect(msg).to match(/Cannot find virtual machine \"#{name}\" under cloud service \"#{csn}\"/)
      end

    end

    describe '#start_virtual_machine' do
      before do
        subject.shutdown_virtual_machine(vm_name, csn)
      end

      it 'starts virtual machine' do
        subject.start_virtual_machine(vm_name, csn)
        vm = subject.get_virtual_machine(vm_name, csn)
        statuses = %w(ReadyRole Provisioning CreatingVM RoleStateUnknown)
        expect(statuses).to include(vm.status)
      end

    end

    describe '#restart_virtual_machine' do
      before do
        subject.restart_virtual_machine(vm_name, csn)
      end

      it 'restarts virtual machine' do
        vm = subject.get_virtual_machine(vm_name, csn)
        expect(%w(ReadyRole Provisioning RoleStateUnknown)).to include(vm.status)
      end
    end

    describe '#get_virtual_machine' do
      it 'should return virtual machine object' do
        vm = subject.get_virtual_machine(vm_name, csn)
        expect(vm.vm_name).to eq(vm_name)
        expect(vm.cloud_service_name).to eq(csn)
      end
    end

    describe '#list_virtual_machines' do
      it 'returns a list of virtual machines' do
        vms = subject.list_virtual_machines
        expect(vms).not_to be_nil
        expect(vms).to be_a_kind_of(Array)
        vm = vms.first
        expect(vm).to be_a_kind_of(Azure::VirtualMachineManagement::VirtualMachine)
        vm_names = vms.map(&:vm_name)
        expect(vm_names).to include(vm.vm_name)
      end
    end

    describe '#add_data_disk' do
      it 'add data disk to virtual machine' do
        others = { disk_size: 100 }
        subject.add_data_disk(vm_name, csn, others)
        dms = VirtualMachineDiskManagementService.new
        disks = dms.list_virtual_machine_disks
        disks = disks.select { |x| (/#{csn}/ =~ x.name) && x.os_type.empty? }
        expect(disks.size).to be >= 1
        expect(disks.first.size).to eq(others[:disk_size].to_s)
      end
    end

    describe 'Add, Update, Delete endpoints' do

      it 'should add endpoints to virtual machine.' do
        ep1 =  {
          name: 'endpoint-1',
          public_port: 777,
          local_port: 777,
          protocol: 'UDP',
        }
        ep2 =  {
          name: 'endpoint-2',
          public_port: 888,
          local_port: 889,
          protocol: 'UDP',
          load_balancer_name: 'lb',
          load_balancer: { protocol: 'http', path: 'mypath' }
        }
        subject.update_endpoints(vm_name, csn,  ep1, ep2)
        vm = subject.get_virtual_machine(vm_name, csn)
        expect(vm.udp_endpoints.size).to eq(2)
        expect(vm.udp_endpoints.first[:name]).to eq('endpoint-1')
        expect(vm.udp_endpoints.last[:name]).to eq('endpoint-2')
      end

      it 'should update existing endpoints of virtual machine.' do
        ep1 =  {
          name: 'SSH',
          public_port: 2222,
          local_port: 22,
          protocol: 'TCP',
        }
        subject.update_endpoints(vm_name, csn,  ep1)
        vm = subject.get_virtual_machine(vm_name, csn)
        expect(vm.tcp_endpoints.size).to eq(1)
        expect(vm.tcp_endpoints.first[:name]).to eq('SSH')
        expect(vm.tcp_endpoints.first[:public_port]).to eq('2222')
      end

      it 'should delete endpoint of virtual machine.' do
        subject.delete_endpoint(vm_name, csn,  'SSH')
        vm = subject.get_virtual_machine(vm_name, csn)
        expect(vm.tcp_endpoints.size).to eq(0)
        ep1 =  {
          name: 'SSH',
          public_port: 22,
          local_port: 22,
          protocol: 'TCP',
        }
        subject.update_endpoints(vm_name, csn,  ep1)
      end
    end

  end
end # end
