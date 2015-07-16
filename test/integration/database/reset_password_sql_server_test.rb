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
require_relative '../test_helper'

describe Azure::SqlDatabaseManagementService do

  subject { Azure::SqlDatabaseManagementService.new }
  let(:login_name) {'test_login'}
  let(:sql_server) { subject.create_server(login_name, 'User1@123', WindowsImageLocation) }

  describe '#reset_password' do

    after {
      subject.delete_server(sql_server.name)
    }

    it 'should be able to reset password of sql database server.' do
      subject.reset_password(sql_server.name, 'User2@123')
    end

    it 'raise if the sql server does not exist' do
      expect { subject.reset_password('unknown-server', 'User2@123') }.to raise_error(Azure::SqlDatabaseManagement::ServerDoesNotExist)
    end

    it 'error if the sql server password is invalid' do
      password = 'weak'
      expect { subject.reset_password(sql_server.name, password) }.to raise_error(RuntimeError, /Password validation failed/i)
    end

  end

end
