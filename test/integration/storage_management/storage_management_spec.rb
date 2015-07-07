#-------------------------------------------------------------------------
# Copyright 2015 Microsoft Open Technologies, Inc.
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

describe StorageManagementClient do

  util = Class.new.extend(Utility)
  token_credential = TokenCloudCredentials.new(SubscriptionId, AccessToken)
  subject { Azure::StorageManagementClient.new(token_credential) }
  affinity_name = util.random_string('affinity-group-', 10)
  # Azure::BaseManagementService.new.create_affinity_group(
  #     affinity_name,
  #     'West US',
  #     'Label Name'
  # )
  StorageName = 'dbteststorage1' #util.random_string('storagetest', 10)
  # opts = {
  #     affinity_group_name: affinity_name,
  #     label: 'storagelabel',
  #     description: 'This is a storage account',
  #     geo_replication_enabled: 'true'
  # }
  # Azure::StorageManagementService.new.create_storage_account(StorageName, opts)

  let(:affinity_group_name) { affinity_name }
  let(:storage_name) { Time.now.getutc.to_i.to_s }
  let(:label) { 'Label Name' }
  let(:options) { { description: 'sample description' } }

  it 'list storage accounts' do
    storagelist = subject.storage_accounts.list().value!
    expect(storagelist.body.value).not_to be_nil
    expect(storagelist.body.value).to be_a(Array)
  end

  it 'should send true if name is available' do
    acc_name = Models::StorageAccountCheckNameAvailabilityParameters.new()
    acc_name.name = 'nonexistentstorage'
    acc_name.type = 'Microsoft.Storage/storageAccounts'
    storage = subject.storage_accounts.check_name_availability(acc_name).value!
    expect(storage.body.message).to be_nil
    expect(storage.body.name_available).to be_truthy
    expect(storage.body.reason).to be_nil
    expect(storage.response).to be_an_instance_of(Net::HTTPOK)
  end

  it 'create storage account' do
    props = Models::StorageAccountPropertiesCreateParametersJson.new
    props.account_type = 'Standard_LRS'

    params = Models::StorageAccountCreateParameters.new
    params.properties = props
    params.location = 'WestUS'

    result = subject.storage_accounts.create(ResourceGroup, StorageName, params).value!
    expect(result.responce).to be_an_instance_of(Net::HTTPOK)
  end

  # it 'get storage account' do
  #   storage_name = StorageName
  #   storage_account = subject.get_storage_account(storage_name)
  #   expect(storage_account).to be_an_instance_of(Azure::StorageManagement::StorageAccount)
  # end

  it 'get storage account properties' do
    storage = subject.storage_accounts.get_properties(ResourceGroup, StorageName).value!
    expect(storage.body.name).to eq(StorageName)
    expect(storage.body.type).to eq('Microsoft.Storage/storageAccounts')
  end

  it 'regenerate storage account keys' do
    params = Models::StorageAccountRegenerateKeyParameters.new
    params.key_name = 'key1'

    storage_keys1 = subject.storage_accounts.regenerate_key(ResourceGroup, StorageName, params).value!
    expect(storage_keys1.body.key1).not_to be_nil
    expect(storage_keys1.body.key2).not_to be_nil

    params.key_name = 'key2'
    storage_keys2 = subject.storage_accounts.regenerate_key(ResourceGroup, StorageName, params).value!
    expect(storage_keys1.body.key1).to eq(storage_keys2.body.key1)
    expect(storage_keys1.body.key2).not_to eq(storage_keys2.body.key2)
  end

  it 'get storage account keys' do
    storage_keys1 = subject.storage_accounts.list_keys(ResourceGroup, StorageName).value!
    expect(storage_keys1.body.key1).not_to be_nil
    expect(storage_keys1.body.key2).not_to be_nil
  end

  # it 'get storage account properties error' do
  #   storage_name = 'invalidstorage'
  #   exception = assert_raises(RuntimeError) do
  #     subject.get_storage_account_properties(storage_name)
  #   end
  #   assert_match(/The storage account 'invalidstorage' was not found/, exception.message)
  # end

  # it 'create storage account with invalid storage name' do
  #   options = {
  #       affinity_group_name: 'affinitygrouptest',
  #       label: 'storagelabel',
  #       description: 'This is a storage account',
  #       geo_replication_enabled: 'false'
  #   }
  #   storage_name = 'ba'
  #   exception = assert_raises(RuntimeError) do
  #     subject.create_storage_account(storage_name, options)
  #   end
  #   assert_match(/Storage account names must be between 3 and 24/, exception.message)
  # end

  # it 'create storage account with invalid location' do
  #   options = {
  #       location: 'West1 US',
  #       label: 'storagelabel',
  #       description: 'This is a storage account',
  #       geo_replication_enabled: 'false'
  #   }
  #   exception = assert_raises(RuntimeError) do
  #     subject.create_storage_account(storage_name, options)
  #   end
  #   assert_match('The location constraint is not valid', exception.message)
  # end

  # it 'create storage account with invalid affinity group' do
  #   options = {
  #       affinity_group_name: 'invalidaffinitygroup',
  #       label: 'storagelabel',
  #       description: 'This is a storage account',
  #       geo_replication_enabled: 'false'
  #   }
  #   exception = assert_raises(RuntimeError) do
  #     subject.create_storage_account(storage_name, options)
  #   end
  #   assert_match('The affinity group does not exist.', exception.message)
  # end

  # it 'delete storage account that does not exist' do
  #   msg = subject.delete_storage_account('invalidstorageaccount')
  #   assert_match(/The storage account 'invalidstorageaccount' was not found./, msg)
  # end

  # describe '#update_storage_account' do
  #
  #   it 'update storage account with non existent storage name' do
  #     options = {
  #         label: 'labelchanged',
  #         description: 'description changed'
  #     }
  #     storage_name = 'storage_nonexistent'
  #     storage = subject.update_storage_account(storage_name, options)
  #     error_msg = "Storage Account 'storage_nonexistent' does not exist"
  #     assert_match(/#{error_msg}/, storage)
  #   end
  #
  #   it 'update existing storage account' do
  #     options = {
  #         label: 'labelchanged',
  #         description: 'description changed',
  #         account_type: 'Standard_LRS'
  #     }
  #     storage_name = StorageName
  #     subject.update_storage_account(storage_name, options)
  #     storage = subject.get_storage_account_properties(storage_name)
  #     expect(storage.name).to eq(storage_name)
  #     expect(storage.label).to eq('labelchanged')
  #     expect(storage.account_type).to eq('Standard_LRS')
  #     opts[:account_type] = 'Standard_GRS'
  #     subject.update_storage_account(storage_name, opts)
  #   end
  # end
end
