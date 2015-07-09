#-------------------------------------------------------------------------
# Copyright 2013 Microsoft Open Technologies, Inc.
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
require 'integration/test_helper'

describe Azure::SqlDatabaseManagementService do

  let(:login_name) { 'test_login' }
  let(:sql_server) { subject.create_server(login_name, 'User1@123', WindowsImageLocation) }
  subject { Azure::SqlDatabaseManagementService.new }

  before {
    Azure::Loggerx.expects(:puts).returns(nil).at_least(0)
    subject.set_sql_server_firewall_rule(sql_server.name, 'rule1', '0.0.0.0', '255.255.255.255')
    subject.set_sql_server_firewall_rule(sql_server.name, 'rule2', '10.20.30.0', '10.20.30.255')
  }

  after {
    subject.delete_server(sql_server.name)
  }

  describe '#delete_sql_server_firewall_rule' do

    it 'delete sql database server firewall' do
      server_name = sql_server.name
      subject.delete_sql_server_firewall_rule(server_name, 'rule1')

      sql_server_firewalls = subject.list_sql_server_firewall_rules(server_name)
      expect(sql_server_firewalls).to be_a_kind_of(Array)
      expect(sql_server_firewalls.first).to be_a_kind_of(Azure::SqlDatabaseManagement::FirewallRule)
      expect(sql_server_firewalls.size).to eq(1)
      firewall = sql_server_firewalls.first
      expect(firewall.name).to eq('rule2')
      expect(firewall.end_ip_address).to eq('10.20.30.255')
      expect(firewall.start_ip_address).to eq('10.20.30.0')
    end

    it 'errors if the sql server does not exist' do
      expect { subject.delete_sql_server_firewall_rule('unknown-server', 'rule1') }.to raise_error(Azure::SqlDatabaseManagement::ServerDoesNotExist)
    end

    it 'returns false if the sql server firewall rule does not exist when deleting' do
      expect { subject.delete_sql_server_firewall_rule(sql_server.name, rule10) }.to raise_error(Azure::SqlDatabaseManagement::RuleDoesNotExist)
    end

  end

end

