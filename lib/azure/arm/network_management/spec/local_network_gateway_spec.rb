# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require_relative 'test_helper'
require_relative 'local_network_gateway_shared'

include MsRestAzure
include Azure::ARM::Resources
include Azure::ARM::Network

describe LocalNetworkGateways do

  before(:all) do
    @client = NETWORK_CLIENT.local_network_gateways
    @location = 'westus'
    @resource_group = create_resource_group
  end
  after(:all) do
    delete_resource_group(@resource_group.name)
  end

  it 'should create local network gateway' do
    params = build_local_network_gateway_params(@location)
    result = @client.create_or_update(@resource_group.name, params.name, params).value!
    expect(result.response.status).to eq(200)
    expect(result.body).not_to be_nil
    expect(result.body.name).to eq(params.name)
  end

  it 'should get local network gateway' do
    local_network_gateway = create_local_network_gateway(@resource_group, @location)
    result = @client.get(@resource_group.name, local_network_gateway.name).value!
    expect(result.response.status).to eq(200)
    expect(result.body).not_to be_nil
    expect(result.body.name).to eq(local_network_gateway.name)
  end

  it 'should delete local network gateway' do
    local_network_gateway = create_local_network_gateway(@resource_group, @location)
    result = @client.delete(@resource_group.name, local_network_gateway.name).value!
    expect(result.response.status).to eq(200)
  end

  it 'should list all the local network gateways' do
    result = @client.list(@resource_group.name).value!
    expect(result.response.status).to eq(200)
    expect(result.body).not_to be_nil
    expect(result.body.value).to be_a(Array)
    until result.body.next_link.to_s.empty? do
      result = @client.list_next(result.body.next_link).value!
      expect(result.body.value).not_to be_nil
      expect(result.body.value).to be_a(Array)
    end
  end


end