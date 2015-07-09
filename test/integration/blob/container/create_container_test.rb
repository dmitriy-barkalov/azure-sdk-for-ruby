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
require 'integration/test_helper'
require 'azure/blob/blob_service'
require 'azure/core/http/http_error'

describe Azure::Blob::BlobService do
  subject { Azure::Blob::BlobService.new }
  after { TableNameHelper.clean }

  describe '#create_container' do
    let(:container_name) { ContainerNameHelper.name }

    it 'creates the container' do
      container = subject.create_container container_name
      expect(container.name).to eq(container_name)
    end

    it 'creates the container with custom metadata' do
      metadata = { 'CustomMetadataProperty' => 'CustomMetadataValue'}

      container = subject.create_container container_name, { :metadata => metadata }
      
      expect(container.name).to eq(container_name)
      expect(container.metadata).to eq(metadata)
      container = subject.get_container_metadata container_name

      metadata.each { |k,v|
        expect(container.metadata).to include(k.downcase)
        expect(container.metadata[k.downcase]).to eq(v)
      }
    end

    it 'errors if the container already exists' do
      subject.create_container container_name
      
      expect { subject.create_container container_name }.to raise_error(Azure::Core::Http::HTTPError)
    end
    
    it 'errors if the container name is invalid' do
      expect { subject.create_container 'this_container.cannot-exist!' }.to raise_error(Azure::Core::Http::HTTPError)
    end
  end
end
