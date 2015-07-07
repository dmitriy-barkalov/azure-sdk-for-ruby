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


# Azure.configure do |config|
#   config.storage_access_key       = ENV.fetch('AZURE_STORAGE_ACCESS_KEY')
#   config.storage_account_name     = ENV.fetch('AZURE_STORAGE_ACCOUNT')
#   config.sb_namespace             = ENV.fetch('AZURE_SERVICEBUS_NAMESPACE')
#   config.sb_access_key            = ENV.fetch('AZURE_SERVICEBUS_ACCESS_KEY')
#   config.management_certificate   = ENV.fetch('AZURE_MANAGEMENT_CERTIFICATE')
#   config.subscription_id          = ENV.fetch('AZURE_SUBSCRIPTION_ID')
# end
#
# util = Class.new.extend(Azure::Core::Utility)
#
# StorageAccountName = util.random_string('storagetest',10)
# Images = Azure::VirtualMachineImageManagementService.new.list_virtual_machine_images
# LinuxImage = Images.select{|image| image.os_type == 'Linux'}.first
# WindowsImage = Images.select{|image| image.os_type == 'Windows'}.first
# locations = WindowsImage.locations.split(';')
# WindowsImageLocation = locations.include?('West US') ? 'West US' : locations.first
# locations = LinuxImage.locations.split(';')
# LinuxImageLocation = locations.include?('West US') ? 'West US' : locations.first
#
# MiniTest.after_run {
#   VirtualMachineNameGenerator.cleanup
# }

ResourceGroup = 'RubySDKTest'

AccessToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ik1uQ19WWmNBVGZNNXBPWWlKSE1iYTlnb0VLWSIsImtpZCI6Ik1uQ19WWmNBVGZNNXBPWWlKSE1iYTlnb0VLWSJ9.eyJhdWQiOiJodHRwczovL21hbmFnZW1lbnQuY29yZS53aW5kb3dzLm5ldC8iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC83MmY5ODhiZi04NmYxLTQxYWYtOTFhYi0yZDdjZDAxMWRiNDcvIiwiaWF0IjoxNDM2MjYwMzkyLCJuYmYiOjE0MzYyNjAzOTIsImV4cCI6MTQzNjI2NDI5MiwidmVyIjoiMS4wIiwidGlkIjoiNzJmOTg4YmYtODZmMS00MWFmLTkxYWItMmQ3Y2QwMTFkYjQ3Iiwib2lkIjoiNzdjMWI0NTgtZGFhYS00OWUxLWFlZWYtNmRkNWI1ODU2OTk5IiwiZW1haWwiOiJkbWl0cnkuYmFya2Fsb3ZAYWt2ZWxvbi5jb20iLCJwdWlkIjoiMTAwMzdGRkU5MTY3NTQ0RCIsImlkcCI6ImxpdmUuY29tIiwiYWx0c2VjaWQiOiIxOmxpdmUuY29tOjAwMDNCRkZEQ0UzMjlENUYiLCJzdWIiOiJGZnoyV1VUNTM2XzFiaHJzT2kzOTd5WGhvX0dzUF84ZWZmWXFnTW1DSU9VIiwiZ2l2ZW5fbmFtZSI6IkRtaXRyaXkiLCJmYW1pbHlfbmFtZSI6IkJhcmthbG92IiwibmFtZSI6ImRtaXRyeS5iYXJrYWxvdkBha3ZlbG9uLmNvbSIsImFtciI6WyJwd2QiXSwidW5pcXVlX25hbWUiOiJsaXZlLmNvbSNkbWl0cnkuYmFya2Fsb3ZAYWt2ZWxvbi5jb20iLCJhcHBpZCI6IjA0YjA3Nzk1LThkZGItNDYxYS1iYmVlLTAyZjllMWJmN2I0NiIsImFwcGlkYWNyIjoiMCIsInNjcCI6InVzZXJfaW1wZXJzb25hdGlvbiIsImFjciI6IjEifQ.G-1cpFEprEVUMhK8CQr7kLmSLjRwtwBb43vZAgOP7WUiV92xXAAG6s9QhmOJPpRCKBYj-5rU7_TvMj5fD-4gxjRxurWfbEDI8UDU8znJL71Fa86hrlHwMrWjgL2J9hJ0q_VguTx6jR9uPhalQ2aUs8xZnbx7eCzACy7crheTTEX_NJmBGuIrf3dSyAC3KVcOpXrjwWoHnd13fcRtnJpgkHrOujs-TK0MNftvjkl2jNq2tAm3kWEbIQTtMDPeysMIkAIrihwoP-oldpnV3Bsdr_tUOo4UM0H5pb9SfeRP93wmO8unulp5JKa46x-F4qJ-tZJqTf_P18HsSPdDv6IbVw'
SubscriptionId = '02286c5c-1f73-4bd4-82b7-761b50edfa78'
