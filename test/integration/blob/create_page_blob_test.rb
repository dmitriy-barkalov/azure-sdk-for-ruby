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


describe Azure::Blob::BlobService do
  subject { Azure::Blob::BlobService.new }
  after { TableNameHelper.clean }
  
  describe '#create_page_blob' do
    let(:container_name) { ContainerNameHelper.name }
    let(:blob_name) { "blobname" }
    let(:complex_blob_name) { 'qa-872053-/*"\'&.({[<+ ' + [ 0x7D, 0xEB, 0x8B, 0xA4].pack('U*') + '_' + "0" }
    let(:length) { 1024 }
    before { 
      subject.create_container container_name
    }

    it 'creates a page blob' do
      blob = subject.create_page_blob container_name, blob_name, length
      expect(blob.name).to eq(blob_name)
    end

    it 'creates a page blob with complex name' do
      blob = subject.create_page_blob container_name, complex_blob_name, length
      expect(blob.name).to eq(complex_blob_name)

      complex_blob_name.force_encoding("UTF-8")
      found_complex_name = false
      result = subject.list_blobs container_name
      result.each { |blob|
        found_complex_name = true if blob.name == complex_blob_name
      }

      expect(found_complex_name).to eq(true)
    end

    it 'sets additional properties when the options hash is used' do
      options = {
        :content_type=>"application/xml",
        :content_encoding=>"utf-8",
        :content_language=>"en-US",
        :cache_control=>"max-age=1296000",
        :metadata => { "CustomMetadataProperty"=>"CustomMetadataValue"}
      }

      blob = subject.create_page_blob container_name, blob_name, length, options
      blob = subject.get_blob_properties container_name, blob_name
      expect(blob.name).to eq(blob_name)
      expect(blob.properties[:content_type]).to eq(options[:content_type])
      expect(blob.properties[:content_encoding]).to eq(options[:content_encoding])
      expect(blob.properties[:cache_control]).to eq(options[:cache_control])

      blob = subject.get_blob_metadata container_name, blob_name
      expect(blob.name).to eq(blob_name)
      expect(blob.metadata["custommetadataproperty"]).to eq("CustomMetadataValue")
    end

    it 'errors if the container does not exist' do
      expect { subject.create_page_blob ContainerNameHelper.name, blob_name, length }.to raise_error(Azure::Core::Http::HTTPError)
    end

    it 'errors if the length is not 512 byte aligned' do
      expect { subject.create_page_blob container_name, blob_name, length + 1 }.to raise_error(Azure::Core::Http::HTTPError)
    end
  end
end
