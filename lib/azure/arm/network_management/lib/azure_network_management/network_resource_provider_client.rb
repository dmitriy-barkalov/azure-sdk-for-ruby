# Code generated by Microsoft (R) AutoRest Code Generator 0.11.0.0
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module Azure::ARM::Network
  #
  # A service client - single point of access to the REST API.
  #
  class NetworkResourceProviderClient < MsRestAzure::AzureServiceClient
    include Azure::ARM::Network::Models
    include MsRestAzure

    # @return [String] the base URI of the service.
    attr_accessor :base_url

    # @return [ServiceClientCredentials] The management credentials for Azure.
    attr_reader :credentials

    # @return [String] Gets subscription credentials which uniquely identify
    # Microsoft Azure subscription. The subscription ID forms part of the URI
    # for every service call.
    attr_accessor :subscription_id

    # @return [String] Client Api Version.
    attr_reader :api_version

    # @return [String] Gets or sets the preferred language for the response.
    attr_accessor :accept_language

    # @return [Integer] The retry timeout for Long Running Operations.
    attr_accessor :long_running_operation_retry_timeout

    # @return [ServiceClient] Subscription credentials which uniquely identify
    # client subscription.
    attr_accessor :credentials

    # @return application_gateways
    attr_reader :application_gateways

    # @return load_balancers
    attr_reader :load_balancers

    # @return local_network_gateways
    attr_reader :local_network_gateways

    # @return network_interfaces
    attr_reader :network_interfaces

    # @return network_security_groups
    attr_reader :network_security_groups

    # @return public_ip_addresses
    attr_reader :public_ip_addresses

    # @return security_rules
    attr_reader :security_rules

    # @return subnets
    attr_reader :subnets

    # @return usages
    attr_reader :usages

    # @return virtual_network_gateway_connections
    attr_reader :virtual_network_gateway_connections

    # @return virtual_network_gateways
    attr_reader :virtual_network_gateways

    # @return virtual_networks
    attr_reader :virtual_networks

    #
    # Creates initializes a new instance of the NetworkResourceProviderClient class.
    # @param credentials [MsRest::ServiceClientCredentials] credentials to authorize HTTP requests made by the service client.
    # @param base_url [String] the base URI of the service.
    # @param options [Array] filters to be applied to the HTTP requests.
    #
    def initialize(credentials, base_url = nil, options = nil)
      super(credentials, options)
      @base_url = base_url || 'https://management.azure.com'

      fail ArgumentError, 'credentials is nil' if credentials.nil?
      fail ArgumentError, 'invalid type of credentials input parameter' unless credentials.is_a?(MsRest::ServiceClientCredentials)
      @credentials = credentials

      @application_gateways = ApplicationGateways.new(self)
      @load_balancers = LoadBalancers.new(self)
      @local_network_gateways = LocalNetworkGateways.new(self)
      @network_interfaces = NetworkInterfaces.new(self)
      @network_security_groups = NetworkSecurityGroups.new(self)
      @public_ip_addresses = PublicIpAddresses.new(self)
      @security_rules = SecurityRules.new(self)
      @subnets = Subnets.new(self)
      @usages = Usages.new(self)
      @virtual_network_gateway_connections = VirtualNetworkGatewayConnections.new(self)
      @virtual_network_gateways = VirtualNetworkGateways.new(self)
      @virtual_networks = VirtualNetworks.new(self)
      @api_version = "2015-05-01-preview"
      @accept_language = "en-US"
    end

    #
    # Checks whether a domain name in the cloudapp.net zone is available for use.
    # @param location [String] The location of the domain name
    # @param domain_name_label [String] The domain name to be verified. It must
    # conform to the following regular expression: ^[a-z][a-z0-9-]{1,61}[a-z0-9]$.
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def check_dns_name_availability(location, domain_name_label = nil, custom_headers = nil)
      fail ArgumentError, 'location is nil' if location.nil?
      fail ArgumentError, 'api_version is nil' if api_version.nil?
      fail ArgumentError, 'subscription_id is nil' if subscription_id.nil?
      # Construct URL
      path = "/subscriptions/{subscriptionId}/providers/Microsoft.Network/locations/{location}/CheckDnsNameAvailability"
      path['{location}'] = ERB::Util.url_encode(location) if path.include?('{location}')
      path['{subscriptionId}'] = ERB::Util.url_encode(subscription_id) if path.include?('{subscriptionId}')
      url = URI.join(self.base_url, path)
      properties = {}
      properties['domainNameLabel'] = ERB::Util.url_encode(domain_name_label.to_s) unless domain_name_label.nil?
      properties['api-version'] = ERB::Util.url_encode(api_version.to_s) unless api_version.nil?
      unless url.query.nil?
        url.query.split('&').each do |url_item|
          url_items_parts = url_item.split('=')
          properties[url_items_parts[0]] = url_items_parts[1]
        end
      end
      properties.reject!{ |key, value| value.nil? }
      url.query = properties.map{ |key, value| "#{key}=#{value}" }.compact.join('&')
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      # Set Headers
      request_headers['x-ms-client-request-id'] = SecureRandom.uuid
      request_headers["accept-language"] = accept_language unless accept_language.nil?

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.get do |request|
          request.headers = request_headers
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 200)
          error_model = JSON.load(response_content)
          fail MsRestAzure::AzureOperationError.new(connection, http_response, error_model)
        end

        # Create Result
        result = MsRestAzure::AzureOperationResponse.new(connection, http_response)
        result.request_id = http_response['x-ms-request-id'] unless http_response['x-ms-request-id'].nil?
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = JSON.load(response_content) unless response_content.to_s.empty?
            unless parsed_response.nil?
              parsed_response = DnsNameAvailabilityResult.deserialize_object(parsed_response)
            end
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new("Error occured in deserializing the response", e.message, e.backtrace, response_content)
          end
        end

        result
      end

      promise.execute
    end

  end
end