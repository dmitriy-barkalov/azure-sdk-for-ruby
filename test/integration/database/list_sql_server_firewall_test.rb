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

  subject { Azure::SqlDatabaseManagementService.new }
  let(:login_name) {'test_login'}
  let(:sql_server) { subject.create_server(login_name, 'User1@123', WindowsImageLocation) }
  describe '#list_sql_server_firewall_rules' do

    before {
      Azure::Loggerx.expects(:puts).returns(nil).at_least(0)
      subject.set_sql_server_firewall_rule(sql_server.name, 'rule1', '10.20.30.0', '10.20.30.255')
      subject.set_sql_server_firewall_rule(sql_server.name, 'rule2')
    }

    after {
      subject.delete_server(sql_server.name)
    }

    it 'returns a list of SQL databse server firewall' do
      sql_server_firewalls = subject.list_sql_server_firewall_rules(sql_server.name)
      expect(sql_server_firewalls).not_to be_nil
      expect(sql_server_firewalls).to be_a_kind_of(Array)
      expect(sql_server_firewalls.first).to be_a_kind_of(Azure::SqlDatabaseManagement::FirewallRule)
      expect(sql_server_firewalls.size).to eq(2)
    end

  end

end
