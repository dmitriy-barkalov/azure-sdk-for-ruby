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
  include Azure::Core::Utility

  subject { Azure::BaseManagementService.new }
  let(:affinity_group_name) { random_string('affinity-group-', 10) }
  let(:image_location) { WindowsImageLocation }

  let(:label) { 'Label Name' }
  let(:options) { { description: 'sample description' } }

  describe '#create_affinity_group' do

    it 'create new affinity group with valid params' do
      subject.create_affinity_group(affinity_group_name,
                                    image_location,
                                    label,
                                    options)
      affinity_group = subject.get_affinity_group(affinity_group_name)
      expect(affinity_group).to be_a_kind_of(Azure::BaseManagement::AffinityGroup)
      expect(affinity_group.name).not_to be_nil
      expect(affinity_group.location).to eq(image_location)
      expect(affinity_group.name).to eq(affinity_group_name)
      expect(affinity_group.label).to eq(label)
      expect(affinity_group.description).to eq(options[:description])
    end

    it 'errors if the affinity group location is not valid' do
      expect { subject.create_affinity_group(affinity_group_name, 'North West', label) }.to raise_error(RuntimeError, /Allowed values are /i)
    end

    it 'create new affinity group without optional params' do
      subject.create_affinity_group(affinity_group_name, image_location, label)
      affinity_group = subject.get_affinity_group(affinity_group_name)
      expect(affinity_group).to be_a_kind_of(Azure::BaseManagement::AffinityGroup)
      expect(affinity_group.name).not_to be_nil
      expect(affinity_group.location).to eq(image_location)
      expect(affinity_group.name).to eq(affinity_group_name)
      expect(affinity_group.label).to eq(label)
    end
  end
end
