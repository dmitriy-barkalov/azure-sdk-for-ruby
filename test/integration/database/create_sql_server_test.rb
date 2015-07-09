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
  describe '#create_server' do

    before {
      Azure::Loggerx.expects(:puts).returns(nil).at_least(0)
    }

    it 'should be able to create a new sql database server.' do
      sql_server = subject.create_server(login_name, 'User@123', WindowsImageLocation)
      expect(sql_server.name).not_to be_nil
      expect(sql_server.location).to eq(WindowsImageLocation)
      expect(sql_server.administrator_login).to eq(login_name)
      subject.delete_server sql_server.name
    end

    it 'errors if the sql server location does not exist' do
      location = 'unknown-location'
      expect { subject.create_server(login_name, 'User@123', location) }.to raise_error(RuntimeError, /Location \'#{location}\' cannot be found/i)
    end

    it 'errors if the sql server passsword is invalid' do
      password = 'weak'
      expect { subject.create_server(login_name, password, WindowsImageLocation) }.to raise_error(RuntimeError, /Password validation failed/i)
    end

  end

end
