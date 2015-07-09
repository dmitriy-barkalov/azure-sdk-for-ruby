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

  describe '#set/get_blob_properties' do
    let(:container_name) { ContainerNameHelper.name }
    let(:blob_name) { "blobname" }
    let(:length) { 1024 }
    before { 
      subject.create_container container_name
      subject.create_page_blob container_name, blob_name, length
    }
    let(:options){{
        :blob_content_type=>"application/my-special-format",
        :blob_content_encoding=>"utf-16",
        :blob_content_language=>"klingon",
        :blob_cache_control=>"max-age=1296000",
      }}

    it 'sets and gets properties for a blob' do
      result = subject.set_blob_properties container_name, blob_name, options
      expect(result).to be_nil
      blob = subject.get_blob_properties container_name, blob_name
      expect(blob.properties[:content_type]).to eq(options[:blob_content_type])
      expect(blob.properties[:content_encoding]).to eq(options[:blob_content_encoding])
      expect(blob.properties[:cache_control]).to eq(options[:blob_cache_control])
    end

    describe 'when a blob has a snapshot' do
      before {
        subject.set_blob_properties container_name, blob_name, options
      }
      
      it 'gets properties for a blob snapshot' do
        snapshot = subject.create_blob_snapshot container_name, blob_name
        blob = subject.get_blob_properties container_name, blob_name, { :snapshot => snapshot }

        expect(blob.snapshot).to eq(snapshot)
        expect(blob.properties[:content_type]).to eq(options[:blob_content_type])
        expect(blob.properties[:content_encoding]).to eq(options[:blob_content_encoding])
        expect(blob.properties[:cache_control]).to eq(options[:blob_cache_control])
      end

      it 'errors if the snapshot does not exist' do
        expect { subject.get_blob_properties container_name, blob_name, { :snapshot => "invalidsnapshot" } }.to raise_error(Azure::Core::Http::HTTPError)
      end
    end
    
    it 'errors if the blob name does not exist' do
      expect { subject.get_blob_properties container_name, "thisblobdoesnotexist" }.to raise_error(Azure::Core::Http::HTTPError)
      expect { subject.get_blob_properties container_name, "thisblobdoesnotexist", options }.to raise_error(Azure::Core::Http::HTTPError)
    end
  end
end
