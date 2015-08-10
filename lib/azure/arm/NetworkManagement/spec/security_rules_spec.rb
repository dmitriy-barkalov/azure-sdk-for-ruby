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

require_relative 'test_helper'
require_relative 'network_shared'
require_relative 'subnet_shared'
require_relative 'security_groups_shared'

include MsRestAzure
include Azure::ARM::Resources
include Azure::ARM::Network

describe SecurityRules do

  before(:all) do
    @client = NETWORK_CLIENT.security_rules
    @location = 'westus'
    @resource_group = create_resource_group
    @security_group = create_network_security_group(@resource_group, @location)
  end
  after(:all) do
    delete_resource_group(@resource_group.name)
  end

  it 'should create security rule' do
    params = build_security_rule_params
    result = @client.create_or_update(@resource_group.name, @security_group.name, params.name, params).value!
    expect(result.response.status).to eq(200)
    expect(result.body).not_to be_nil
    expect(result.body.name).to eq(params.name)

  end

  it 'should get security rule' do
    security_rule = create_security_rule
    result = @client.get(@resource_group.name, @security_group.name, security_rule.name).value!
    expect(result.response.status).to eq(200)
    expect(result.body).not_to be_nil
    expect(result.body.name).to eq(security_rule.name)
  end

  it 'should delete security rule' do
    security_rule = create_security_rule
    result = @client.delete(@resource_group.name, @security_group.name, security_rule.name).value!
    expect(result.response.status).to eq(200)
  end

  it 'should list all the security rules in a network security group' do
    result = @client.list(@resource_group.name, @security_group.name).value!
    expect(result.response.status).to eq(200)
    expect(result.body).not_to be_nil
    expect(result.body.value).to be_a(Array)
    until result.body.next_link.to_s.empty? do
      result = @client.list_all_next(result.body.next_link).value!
      expect(result.body.value).not_to be_nil
      expect(result.body.value).to be_a(Array)
    end
  end

  def create_security_rule
    params = build_security_rule_params
    @client.create_or_update(@resource_group.name, @security_group.name, params.name, params).value!.body
  end

  def build_security_rule_params
    params = Models::SecurityRule.new
    params.name = get_random_name('sec_rule')
    props = Models::SecurityRulePropertiesFormat.new
    params.properties = props
    props.access = 'Deny'
    props.destination_address_prefix = '*'
    props.destination_port_range = '123-3500'
    props.direction = 'Outbound'
    props.priority = rand(999)
    props.protocol = 'Udp'
    props.source_address_prefix = '*'
    props.source_port_range = '656'
    params
  end

end