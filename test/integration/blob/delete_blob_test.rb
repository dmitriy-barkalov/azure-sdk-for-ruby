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

  describe '#delete_blob' do
    let(:container_name) { ContainerNameHelper.name }
    let(:blob_name) { "blobname" }
    let(:length) { 1024 }
    before { 
      subject.create_container container_name
      subject.create_page_blob container_name, blob_name, length
    }

    it 'deletes a blob' do
      subject.delete_blob container_name, blob_name
    end

    it 'errors if the container does not exist' do
      expect { subject.delete_blob ContainerNameHelper.name, blob_name }.to raise_error(Azure::Core::Http::HTTPError)
    end

    it 'errors if the blob does not exist' do
      expect { subject.delete_blob container_name, "unknown-blob" }.to raise_error(Azure::Core::Http::HTTPError)
    end

    describe 'when a blob has snapshots' do
      let(:snapshot) {
        subject.create_blob_snapshot container_name, blob_name
      }

      # ensure snapshot gets created before tests run. silly.
      before { s = snapshot }

      it 'deletes the blob, and all the snapshots for the blob, if optional paramters are not used' do
        # verify snapshot exists
        result = subject.list_blobs(container_name, { :snapshots=> true })

        snapshot_exists = false
        result.each { |b|
          snapshot_exists = true if b.name == blob_name and b.snapshot == snapshot
        }
        expect(snapshot_exists).to eq(true)

        # delete blob
        subject.delete_blob container_name, blob_name

        # verify blob is gone and snapshot remains
        result = subject.list_blobs(container_name, { :snapshots=> true })
        expect(result.length).to eq(0)
      end

      it 'the snapshot parameter deletes a specific blob snapshot' do
        # create a second snapshot
        second_snapshot = subject.create_blob_snapshot container_name, blob_name

        # verify two snapshots exist

        result = subject.list_blobs(container_name, { :snapshots=> true })

        snapshots = 0
        result.each { |b|
          snapshots += 1 if b.name == blob_name and b.snapshot != nil
        }
        expect(snapshots).to eq(2)

        subject.delete_blob container_name, blob_name, { :snapshot => snapshot }

        # verify first snapshot is gone and blob remains
        result = subject.list_blobs(container_name, { :snapshots=> true })
        
        snapshots = 0
        blob_exists = false
        result.each { |b|
          blob_exists = true if b.name == blob_name and b.snapshot == nil
          snapshots += 1 if b.name == blob_name and b.snapshot == second_snapshot 
        }
        expect(blob_exists).to eq(true)
        expect(snapshots).to eq(1)
      end

      it 'errors if the snapshot id provided does not exist' do
        expect { subject.delete_blob container_name, blob_name, { :snapshot => "thissnapshotidisinvalid" } }.to raise_error(Azure::Core::Http::HTTPError)
      end

      describe 'when :only is provided in the delete_snapshots parameter' do
        let(:delete_snapshots) { :only }
        it 'deletes all the snapshots for the blob, keeping the blob' do
          # verify snapshot exists
          result = subject.list_blobs(container_name, { :snapshots=> true })

          snapshot_exists = false
          result.each { |b|
            snapshot_exists = true if b.name == blob_name and b.snapshot == snapshot
          }
          expect(snapshot_exists).to eq(true)

          # delete snapshots
          subject.delete_blob container_name, blob_name, { :snapshot => nil, :delete_snapshots => :only }

          # verify snapshot is gone and blob remains
          result = subject.list_blobs(container_name, { :snapshots=> true })
          
          snapshot_exists = false
          blob_exists = false
          result.each { |b|
            blob_exists = true if b.name == blob_name and b.snapshot == nil
            snapshot_exists = true if b.name == blob_name and b.snapshot == snapshot
          }
          expect(blob_exists).to eq(true)
          expect(snapshot_exists).to eq(false)
        end
      end

      describe 'when :include is provided in the delete_snapshots parameter' do
        let(:delete_snapshots) { :include }
        it 'deletes the blob and all of the snapshots for the blob' do
          # verify snapshot exists
          result = subject.list_blobs(container_name, { :snapshots=> true })

          snapshot_exists = false
          result.each { |b|
            snapshot_exists = true if b.name == blob_name and b.snapshot == snapshot
          }
          expect(snapshot_exists).to eq(true)

          # delete snapshots
          subject.delete_blob container_name, blob_name, { :snapshot => nil, :delete_snapshots => :include }

          # verify snapshot is gone and blob remains
          result = subject.list_blobs(container_name, { :snapshots=> true })
          expect(result.length).to eq(0)
        end
      end
    end
  end
end
