require './sdk_requirements'

include ClientRuntime
include ClientRuntimeAzure
include Azure
include Azure::Models

def check_if_name_available(subscriptionId, token)
  token_credential = TokenCloudCredentials.new(subscriptionId, token)
  azure_client = StorageManagementClient.new(token_credential)

  params = StorageAccountCheckNameAvailabilityParameters.new
  params.name = 'fogstorage'
  params.type = 'Microsoft.Storage/storageAccounts'

  begin
    result = azure_client.storage_accounts.check_name_availability(params).value!
    # CheckNameAvailabilityResponse
    p result.body.message
    p result.body.reason
  rescue ClientRuntime::HttpOperationException => e
    p e.response.body
  end
end

def create_storage_account(subscriptionId, token)
  token_credential = TokenCloudCredentials.new(subscriptionId, token)
  azure_client = StorageManagementClient.new(token_credential)

  props = StorageAccountPropertiesCreateParametersJson.new
  props.account_type = 'Standard_LRS'

  params = StorageAccountCreateParameters.new
  params.properties = props
  params.location = 'WestUS'

  begin
    result = azure_client.storage_accounts.create('Api-Default-North-Europe', 'fogstorage40nick', params)
    p result.body
  rescue ClientRuntime::HttpOperationException => e
    p e.body
  end
end

def list_keys(subscriptionId, token)
  token_credential = TokenCloudCredentials.new(subscriptionId, token)
  azure_client = StorageManagementClient.new(token_credential)

  begin
    result = azure_client.storage_accounts.list_keys('Api-Default-North-Europe', 'fogstorage2nick').value!

    # StorageAccountKeys
    p result.body.key1
    p result.body.key2
  rescue ClientRuntime::HttpOperationException => e
    p e.body
  end
end

def regenerate_key(subscriptionId, token)
  token_credential = TokenCloudCredentials.new(subscriptionId, token)
  azure_client = StorageManagementClient.new(token_credential)

  temp = StorageAccountRegenerateKeyParameters.new
  temp.key_name = "helloworld"

  begin
    result = azure_client.storage_accounts.regenerate_key('Api-Default-North-Europe', 'fogstorage2nick', temp).value!
    p result.body
  rescue ClientRuntime::HttpOperationException => e
    p e.body
  end
end


def get_properties(subscriptionId, token)
  token_credential = TokenCloudCredentials.new(subscriptionId, token)
  azure_client = StorageManagementClient.new(token_credential)

  begin
    result = azure_client.storage_accounts.get_properties('Api-Default-North-Europe', 'fogstorage2nick').value!
    p result.body.id
    p result.body.location
  rescue ClientRuntime::DeserializationError => e
    p e.exception_stacktrace
  end
end


token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ik1uQ19WWmNBVGZNNXBPWWlKSE1iYTlnb0VLWSIsImtpZCI6Ik1uQ19WWmNBVGZNNXBPWWlKSE1iYTlnb0VLWSJ9.eyJhdWQiOiJodHRwczovL21hbmFnZW1lbnQuY29yZS53aW5kb3dzLm5ldC8iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC83MmY5ODhiZi04NmYxLTQxYWYtOTFhYi0yZDdjZDAxMWRiNDcvIiwiaWF0IjoxNDM2MTk1ODI2LCJuYmYiOjE0MzYxOTU4MjYsImV4cCI6MTQzNjE5OTcyNiwidmVyIjoiMS4wIiwidGlkIjoiNzJmOTg4YmYtODZmMS00MWFmLTkxYWItMmQ3Y2QwMTFkYjQ3Iiwib2lkIjoiMzdhMjJmYWYtYmZkMC00NzA1LTk0YjItYjZmZmM3ZjZlZjc2IiwiZW1haWwiOiJuaWNrLmxlYmVkZXZAYWt2ZWxvbi5jb20iLCJwdWlkIjoiMTAwM0JGRkQ4Q0RGNTM2QSIsImlkcCI6ImxpdmUuY29tIiwiYWx0c2VjaWQiOiIxOmxpdmUuY29tOjAwMDM3RkZFRDM1ODQ4NTQiLCJzdWIiOiJSMlVfWnNqLTQ2enNCV2VUVFhQZm5nbUFzZkh5cURWZUxOTjlnam5Xc0dVIiwiZ2l2ZW5fbmFtZSI6Ik5pY2siLCJmYW1pbHlfbmFtZSI6IkxlYmVkZXYiLCJuYW1lIjoibmljay5sZWJlZGV2QGFrdmVsb24uY29tIiwiYW1yIjpbInB3ZCJdLCJ1bmlxdWVfbmFtZSI6ImxpdmUuY29tI25pY2subGViZWRldkBha3ZlbG9uLmNvbSIsImFwcGlkIjoiMDRiMDc3OTUtOGRkYi00NjFhLWJiZWUtMDJmOWUxYmY3YjQ2IiwiYXBwaWRhY3IiOiIwIiwic2NwIjoidXNlcl9pbXBlcnNvbmF0aW9uIiwiYWNyIjoiMSJ9.gB3B-4G2RGw0iG-JMyginIT3oaUsNA514B9ZGeXqCikMlqcjvYkBQAEmD-9fvHmtX1Hbn7DxAUdshUWWjHlulPrKSHx5A9Uo3RwNfteueCcysS_qcolk4BOJeTCRkpg0MESiKhFcoau5dRwitAe99_9V0zk9V7epg-IKh41MmrVrqK7Ez8zbBaA2qZHHVgk1P103ZixKwsEJkHo3wfjp-VvQ4bhHM3FBTiuAnvskivo2ZSQWiMNkcAxTIv6oAf7O-GXGw1dbKDFrPvapru_Q4-250AEgcn0tj0f4HeSN_6meX0UYzoHdgazrnt3S38TvM8e_uMzY8IziNjxI8XnJtw'
subscriptionId = '02286c5c-1f73-4bd4-82b7-761b50edfa78'

create_storage_account(subscriptionId, token) # !!!! not_working
list_keys subscriptionId, token
check_if_name_available subscriptionId, token
list_keys subscriptionId, token
regenerate_key subscriptionId, token
get_properties subscriptionId, token