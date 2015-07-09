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
require "azure/blob/blob_service"
require "azure/service/signed_identifier"

describe Azure::Blob::BlobService do
  subject { Azure::Blob::BlobService.new }
  after { TableNameHelper.clean }
  
  describe '#set/get_container_acl' do
    let(:container_name) { ContainerNameHelper.name }
    let(:public_access_level) { :container.to_s }
    let(:identifiers) {
      identifier = Azure::Service::SignedIdentifier.new
      identifier.id = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI="
      identifier.access_policy.start = "2009-09-28T08:49:37.0000000Z"
      identifier.access_policy.expiry = "2009-09-29T08:49:37.0000000Z"
      identifier.access_policy.permission = "rwd"
      [identifier]
    }
    before { 
      subject.create_container container_name
    }

    it 'sets and gets the ACL for the container' do
      container, acl = subject.set_container_acl container_name, public_access_level, { :signed_identifiers => identifiers }
      expect(container).not_to be_nil
      expect(container.name).to eq(container_name)
      expect(container.public_access_level).to eq(public_access_level.to_s)
      expect(acl.length).to eq(identifiers.length)
      expect(acl.first.id).to eq(identifiers.first.id)
      expect(acl.first.access_policy.start).to eq(identifiers.first.access_policy.start)
      expect(acl.first.access_policy.expiry).to eq(identifiers.first.access_policy.expiry)
      expect(acl.first.access_policy.permission).to eq(identifiers.first.access_policy.permission)

      container, acl = subject.get_container_acl container_name
      expect(container).not_to be_nil
      expect(container.name).to eq(container_name)
      expect(container.public_access_level).to eq(public_access_level.to_s)
      expect(acl.length).to eq(identifiers.length)
      expect(acl.first.id).to eq(identifiers.first.id)
      expect(acl.first.access_policy.start).to eq(identifiers.first.access_policy.start)
      expect(acl.first.access_policy.expiry).to eq(identifiers.first.access_policy.expiry)
      expect(acl.first.access_policy.permission).to eq(identifiers.first.access_policy.permission)
    end

    it 'errors if the container does not exist' do
      expect { subject.get_container_acl ContainerNameHelper.name }.to raise_error(Azure::Core::Http::HTTPError)
      expect { subject.set_container_acl ContainerNameHelper.name, public_access_level, { :identifiers => identifiers } }.to raise_error(Azure::Core::Http::HTTPError)
    end
  end
end
