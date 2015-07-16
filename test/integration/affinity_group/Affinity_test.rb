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

describe Azure::BaseManagementService do

  subject { Azure::BaseManagementService.new }
  let(:affinity_group_name) { AffinityGroupNameHelper.name }

  describe '#affinity_group' do
    let(:label_name)  { 'Label' }
    let(:options) { { description: 'Some Description' } }

    it 'get affinity group properties for an existing group' do
      subject.create_affinity_group(affinity_group_name,
                                    WindowsImageLocation,
                                    label_name,
                                    options)
      affinity = subject.get_affinity_group(affinity_group_name)
      expect(affinity).to be_a_kind_of(Azure::BaseManagement::AffinityGroup)
      expect(affinity.name).to eq(affinity_group_name)
      expect(affinity.label).to eq(label_name)
      expect(affinity.description).to eq(options[:description])
      expect(affinity.capability).not_to be_nil
      expect(affinity.capability).not_to eq([])
      AffinityGroupNameHelper.clean
    end

    it 'gets properties for an non existing affinity group name' do
      affinity_group_name = 'unknown'
      begin
        subject.get_affinity_group(affinity_group_name)
      rescue Azure::Error::Error => error
        expect(error.status_code).to eq(404)
        expect(error.type).to eq('AffinityGroupNotFound')
      end
    end
  end
end
