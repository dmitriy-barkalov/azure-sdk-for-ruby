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

describe Azure::Blob::BlobService do
  subject { Azure::Blob::BlobService.new }
  after { TableNameHelper.clean }
  
  describe '#get_container_properties' do
    let(:container_name) { ContainerNameHelper.name }
    let(:metadata) { { "CustomMetadataProperty"=>"CustomMetadataValue" } }

    it 'gets properties and custom metadata for the container' do
      container = subject.create_container container_name, { :metadata => metadata }
      properties = container.properties
      
      container = subject.get_container_properties container_name
      expect(container).not_to be_nil
      expect(container.name).to eq(container_name)
      expect(container.properties[:etag]).to eq(properties[:etag])
      expect(container.properties[:last_modified]).to eq(properties[:last_modified])

      metadata.each { |k,v|
        expect(container.metadata).to include(k.downcase)
        expect(container.metadata[k.downcase]).to eq(v)
      }
    end

    it 'errors if the container does not exist' do
      expect { subject.get_container_properties ContainerNameHelper.name }.to raise_error(Azure::Core::Http::HTTPError)
    end
  end
end
