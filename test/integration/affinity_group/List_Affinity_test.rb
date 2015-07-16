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

describe Azure::BaseManagementService do

  subject { Azure::BaseManagementService.new }
  let(:affinity_group_name) { AffinityGroupNameHelper.name }

  before do
    subject.create_affinity_group(affinity_group_name,
                                  WindowsImageLocation,
                                  'Label Name')
  end

  describe '#list_affinity_groups' do
    it 'list affinity groups' do
      affinity_groups = subject.list_affinity_groups
      affinity_group = affinity_groups.first
      expect(affinity_groups).not_to be_nil
      expect(affinity_groups).to be_a_kind_of(Array)
      expect(affinity_group).to be_a_kind_of(Azure::BaseManagement::AffinityGroup)
      expect(affinity_groups.size).to be >= 1
    end
  end
end
