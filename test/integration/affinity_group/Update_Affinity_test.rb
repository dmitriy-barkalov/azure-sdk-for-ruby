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
  util = Class.new.extend(Azure::Core::Utility)
  AffinityGroupName = util.random_string('affinity-group-', 10)

  Azure::BaseManagementService.new.create_affinity_group(
      AffinityGroupName,
      WindowsImageLocation,
      'Label'
  )

  subject { Azure::BaseManagementService.new }
  let(:affinity_group_name) { AffinityGroupName }

  describe '#update_affinity_group' do
    let(:options) { {description: 'sample description'} }

    it 'update affinity group' do
      label = 'updated label'
      subject.update_affinity_group(affinity_group_name, label)
      affinity_group = subject.get_affinity_group(affinity_group_name)
      expect(affinity_group).not_to be_nil
      expect(affinity_group.label).to eq(label)
    end

    it "update affinity group's description with valid input" do
      label = 'Updated Label'
      subject.update_affinity_group(affinity_group_name, label, options)
      affinity_group = subject.get_affinity_group(affinity_group_name)
      expect(affinity_group).not_to be_nil
      expect(affinity_group.description).to eq(options[:description])
      expect(affinity_group.label).to eq(label)
    end

    it "should update only affinity group's label" do
      label = 'Updated Label'
      affinity_group1 = subject.get_affinity_group(affinity_group_name)
      subject.update_affinity_group(affinity_group_name, label)
      affinity_group = subject.get_affinity_group(affinity_group_name)
      expect(affinity_group).not_to be_nil
      expect(affinity_group.description).to eq(affinity_group1.description)
      expect(affinity_group.label).to eq(label)
    end

    it 'error if description content exceeds allowed limit of 1024 chars' do
      options = {description: 'a' * 1025}
      expect { subject.update_affinity_group(affinity_group_name,
                                             'this is update operation',
                                             options) }
          .to raise_error(RuntimeError, /The description for the affinity group is invalid./i)
    end

    it 'error in case of updating non existing affinity group' do
      affinity_name = 'unkown-affinity-group'
      expect { subject.update_affinity_group(affinity_name, 'updated label', options) }.to raise_error(Azure::Error::Error, /The affinity group does not exist./i)
    end
  end
end
