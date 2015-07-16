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
  
  describe '#set/get_blob_metadata' do
    let(:container_name) { ContainerNameHelper.name }
    let(:blob_name) { "blobname" }
    let(:length) { 1024 }
    let(:metadata){ {"custommetadata" => "CustomMetadataValue"} }
    before { 
      subject.create_container container_name
      subject.create_page_blob container_name, blob_name, length
    }

    it 'sets and gets metadata for a blob' do
      result = subject.set_blob_metadata container_name, blob_name, metadata
      expect(result).to be_nil
      blob = subject.get_blob_metadata container_name, blob_name

      metadata.each { |k,v|
        expect(blob.metadata).to include(k)
        expect(blob.metadata[k]).to eq(v)
      }
    end

    describe 'when a blob has a snapshot' do 
      let(:snapshot) { subject.create_blob_snapshot container_name, blob_name, {:metadata => metadata }}
      before { s = snapshot }

      it 'gets metadata for a blob snapshot (when set during create)' do

        blob = subject.get_blob_metadata container_name, blob_name, { :snapshot => snapshot }

        expect(blob.snapshot).to eq(snapshot)
        metadata.each { |k,v|
          expect(blob.metadata).to include(k)
          expect(blob.metadata[k]).to eq(v)
        }
          
      end

      it 'errors if the snapshot does not exist' do
        expect { subject.get_blob_metadata container_name, blob_name, { :snapshot => "invalidsnapshot" } }.to raise_error(Azure::Core::Http::HTTPError)
      end
    end
    
    it 'errors if the blob name does not exist' do
      expect { subject.get_blob_metadata container_name, "thisblobdoesnotexist" }.to raise_error(Azure::Core::Http::HTTPError)
      expect { subject.set_blob_metadata container_name, "thisblobdoesnotexist", metadata }.to raise_error(Azure::Core::Http::HTTPError)
    end
  end
end
