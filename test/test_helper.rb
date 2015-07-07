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
require_relative '../lib/sdk_requirements'
include ClientRuntimeAzure
include Azure

module Utility
  def random_string(str = 'azure', no_of_char = 5)
    str + (0...no_of_char).map { ('a'..'z').to_a[rand(26)] }.join
  end

  def xml_content(xml, key, default = '')
    content = default
    node = xml.at_css(key)
    content = node.text if node
    content
  end

  def locate_file(name)
    if File.exist? name
      name
    elsif File.exist?(File.join(ENV['HOME'], name))
      File.join(ENV['HOME'], name)
    else
      Azure::Loggerx.error_with_exit "Unable to find #{name} file  "
    end
  end

  def export_der(cert, key, pass = nil, name = nil)
    pkcs12 = OpenSSL::PKCS12.create(pass, name, key, cert)
    Base64.encode64(pkcs12.to_der)
  rescue Exception => e
    puts e.message
    abort
  end

  def export_fingerprint(certificate)
    Digest::SHA1.hexdigest(certificate.to_der)
  end

  def enable_winrm?(winrm_transport)
    (!winrm_transport.nil? && (winrm_transport.select { |x| x.downcase == 'http' || x.downcase == 'https' }.size > 0))
  end

  def get_certificate(private_key_file)
    rsa = OpenSSL::PKey.read File.read(private_key_file)
    cert = OpenSSL::X509::Certificate.new
    cert.version = 2
    cert.serial = 0
    name = OpenSSL::X509::Name.new([['CN', 'Azure Management Certificate']])
    cert.subject = cert.issuer = name
    cert.not_before = Time.now
    cert.not_after = cert.not_before + (60*60*24*365)
    cert.public_key = rsa.public_key
    cert.sign(rsa, OpenSSL::Digest::SHA1.new)
    cert
  end

  def initialize_external_logger(logger)
    Loggerx.initialize_external_logger(logger)
  end
end