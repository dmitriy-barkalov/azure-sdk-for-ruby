# Code generated by Microsoft (R) AutoRest Code Generator 0.11.0.0
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.


require 'uri'
require 'cgi'
require 'date'
require 'json'
require 'base64'
require 'ERB'
require 'securerandom'
require 'time'
require 'timeliness'
require 'faraday'
require 'faraday-cookie_jar'
require 'concurrent'
require 'ms_rest'
require 'ms_rest_azure'

require 'azure_storage_management/module_definition'
require 'azure_storage_management/version'

module Azure::ARM::Storage
  autoload :StorageAccounts,                                    'azure_storage_management/storage_accounts.rb'
  autoload :UsageOperations,                                    'azure_storage_management/usage_operations.rb'
  autoload :StorageManagementClient,                            'azure_storage_management/storage_management_client.rb'

  module Models
    autoload :StorageAccountCheckNameAvailabilityParameters,      'azure_storage_management/models/storage_account_check_name_availability_parameters.rb'
    autoload :CheckNameAvailabilityResult,                        'azure_storage_management/models/check_name_availability_result.rb'
    autoload :StorageAccountPropertiesCreateParameters,           'azure_storage_management/models/storage_account_properties_create_parameters.rb'
    autoload :Endpoints,                                          'azure_storage_management/models/endpoints.rb'
    autoload :CustomDomain,                                       'azure_storage_management/models/custom_domain.rb'
    autoload :StorageAccountProperties,                           'azure_storage_management/models/storage_account_properties.rb'
    autoload :StorageAccountKeys,                                 'azure_storage_management/models/storage_account_keys.rb'
    autoload :StorageAccountListResult,                           'azure_storage_management/models/storage_account_list_result.rb'
    autoload :StorageAccountPropertiesUpdateParameters,           'azure_storage_management/models/storage_account_properties_update_parameters.rb'
    autoload :StorageAccountRegenerateKeyParameters,              'azure_storage_management/models/storage_account_regenerate_key_parameters.rb'
    autoload :UsageName,                                          'azure_storage_management/models/usage_name.rb'
    autoload :Usage,                                              'azure_storage_management/models/usage.rb'
    autoload :UsageListResult,                                    'azure_storage_management/models/usage_list_result.rb'
    autoload :StorageAccountCreateParameters,                     'azure_storage_management/models/storage_account_create_parameters.rb'
    autoload :StorageAccount,                                     'azure_storage_management/models/storage_account.rb'
    autoload :StorageAccountUpdateParameters,                     'azure_storage_management/models/storage_account_update_parameters.rb'
    autoload :Reason,                                             'azure_storage_management/models/reason.rb'
    autoload :AccountType,                                        'azure_storage_management/models/account_type.rb'
    autoload :ProvisioningState,                                  'azure_storage_management/models/provisioning_state.rb'
    autoload :AccountStatus,                                      'azure_storage_management/models/account_status.rb'
    autoload :KeyName,                                            'azure_storage_management/models/key_name.rb'
    autoload :UsageUnit,                                          'azure_storage_management/models/usage_unit.rb'
  end
end