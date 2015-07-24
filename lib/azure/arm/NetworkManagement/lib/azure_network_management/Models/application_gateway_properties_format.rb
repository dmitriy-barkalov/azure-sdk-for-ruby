# Code generated by Microsoft (R) AutoRest Code Generator 0.11.0.0
# Changes may cause incorrect behavior and will be lost if the code is


module Azure::ARM::Network
  module Models
    #
    # Properties of Application Gateway
    #
    class ApplicationGatewayPropertiesFormat
      # @return [ApplicationGatewaySku] Gets or sets sku of application
      # gateway resource
      attr_accessor :sku

      # @return Gets operational state of application gateway resource.
      # Possible values for this property include: 'Stopped', 'Starting',
      # 'Running', 'Stopping'
      attr_accessor :operational_state

      # @return [Array<ApplicationGatewayIpConfiguration>] Gets or sets
      # subnets of application gateway resource
      attr_accessor :gateway_ip_configurations

      # @return [Array<ApplicationGatewaySslCertificate>] Gets or sets ssl
      # certificates of application gateway resource
      attr_accessor :ssl_certificates

      # @return [Array<ApplicationGatewayFrontendIpConfiguration>] Gets or
      # sets frontend IP addresses of application gateway resource
      attr_accessor :frontend_ip_configurations

      # @return [Array<ApplicationGatewayFrontendPort>] Gets or sets frontend
      # ports of application gateway resource
      attr_accessor :frontend_ports

      # @return [Array<ApplicationGatewayBackendAddressPool>] Gets or sets
      # backend address pool of application gateway resource
      attr_accessor :backend_address_pools

      # @return [Array<ApplicationGatewayBackendHttpSettings>] Gets or sets
      # backend http settings of application gateway resource
      attr_accessor :backend_http_settings_collection

      # @return [Array<ApplicationGatewayHttpListener>] Gets or sets HTTP
      # listeners of application gateway resource
      attr_accessor :http_listeners

      # @return [Array<ApplicationGatewayRequestRoutingRule>] Gets or sets
      # request routing rules of application gateway resource
      attr_accessor :request_routing_rules

      # @return [String] Gets or sets Provisioning state of the
      # ApplicationGateway resource Updating/Deleting/Failed
      attr_accessor :provisioning_state

      def initialize
        @gateway_ip_configurations = [];
        @ssl_certificates = [];
        @frontend_ip_configurations = [];
        @frontend_ports = [];
        @backend_address_pools = [];
        @backend_http_settings_collection = [];
        @http_listeners = [];
        @request_routing_rules = [];
      end

      #
      # Validate the object. Throws ArgumentError if validation fails.
      #
      def validate
        @sku.validate unless @sku.nil?
        @gateway_ip_configurations.each{ |e| e.validate if e.respond_to?(:validate) } unless @gateway_ip_configurations.nil?
        @ssl_certificates.each{ |e| e.validate if e.respond_to?(:validate) } unless @ssl_certificates.nil?
        @frontend_ip_configurations.each{ |e| e.validate if e.respond_to?(:validate) } unless @frontend_ip_configurations.nil?
        @frontend_ports.each{ |e| e.validate if e.respond_to?(:validate) } unless @frontend_ports.nil?
        @backend_address_pools.each{ |e| e.validate if e.respond_to?(:validate) } unless @backend_address_pools.nil?
        @backend_http_settings_collection.each{ |e| e.validate if e.respond_to?(:validate) } unless @backend_http_settings_collection.nil?
        @http_listeners.each{ |e| e.validate if e.respond_to?(:validate) } unless @http_listeners.nil?
        @request_routing_rules.each{ |e| e.validate if e.respond_to?(:validate) } unless @request_routing_rules.nil?
      end

      #
      # Serializes given Model object into Ruby Hash.
      # @param object Model object to serialize.
      # @return [Hash] Serialized object in form of Ruby Hash.
      #
      def self.serialize_object(object)
        object.validate
        output_object = {}

        serialized_property = object.sku
        if (serialized_property)
          serialized_property = Azure::ARM::Network::Models::ApplicationGatewaySku.serialize_object(serialized_property)
        end
        output_object['sku'] = serialized_property unless serialized_property.nil?

        serialized_property = object.operational_state
        output_object['operationalState'] = serialized_property unless serialized_property.nil?

        serialized_property = object.gateway_ip_configurations
        if (serialized_property)
          serializedArray = [];
          serialized_property.each do |element|
            if (element)
              element = Azure::ARM::Network::Models::ApplicationGatewayIpConfiguration.serialize_object(element)
            end
            serializedArray.push(element);
          end
          serialized_property = serializedArray;
        end
        output_object['gatewayIpConfigurations'] = serialized_property unless serialized_property.nil?

        serialized_property = object.ssl_certificates
        if (serialized_property)
          serializedArray = [];
          serialized_property.each do |element1|
            if (element1)
              element1 = Azure::ARM::Network::Models::ApplicationGatewaySslCertificate.serialize_object(element1)
            end
            serializedArray.push(element1);
          end
          serialized_property = serializedArray;
        end
        output_object['sslCertificates'] = serialized_property unless serialized_property.nil?

        serialized_property = object.frontend_ip_configurations
        if (serialized_property)
          serializedArray = [];
          serialized_property.each do |element2|
            if (element2)
              element2 = Azure::ARM::Network::Models::ApplicationGatewayFrontendIpConfiguration.serialize_object(element2)
            end
            serializedArray.push(element2);
          end
          serialized_property = serializedArray;
        end
        output_object['frontendIpConfigurations'] = serialized_property unless serialized_property.nil?

        serialized_property = object.frontend_ports
        if (serialized_property)
          serializedArray = [];
          serialized_property.each do |element3|
            if (element3)
              element3 = Azure::ARM::Network::Models::ApplicationGatewayFrontendPort.serialize_object(element3)
            end
            serializedArray.push(element3);
          end
          serialized_property = serializedArray;
        end
        output_object['frontendPorts'] = serialized_property unless serialized_property.nil?

        serialized_property = object.backend_address_pools
        if (serialized_property)
          serializedArray = [];
          serialized_property.each do |element4|
            if (element4)
              element4 = Azure::ARM::Network::Models::ApplicationGatewayBackendAddressPool.serialize_object(element4)
            end
            serializedArray.push(element4);
          end
          serialized_property = serializedArray;
        end
        output_object['backendAddressPools'] = serialized_property unless serialized_property.nil?

        serialized_property = object.backend_http_settings_collection
        if (serialized_property)
          serializedArray = [];
          serialized_property.each do |element5|
            if (element5)
              element5 = Azure::ARM::Network::Models::ApplicationGatewayBackendHttpSettings.serialize_object(element5)
            end
            serializedArray.push(element5);
          end
          serialized_property = serializedArray;
        end
        output_object['backendHttpSettingsCollection'] = serialized_property unless serialized_property.nil?

        serialized_property = object.http_listeners
        if (serialized_property)
          serializedArray = [];
          serialized_property.each do |element6|
            if (element6)
              element6 = Azure::ARM::Network::Models::ApplicationGatewayHttpListener.serialize_object(element6)
            end
            serializedArray.push(element6);
          end
          serialized_property = serializedArray;
        end
        output_object['httpListeners'] = serialized_property unless serialized_property.nil?

        serialized_property = object.request_routing_rules
        if (serialized_property)
          serializedArray = [];
          serialized_property.each do |element7|
            if (element7)
              element7 = Azure::ARM::Network::Models::ApplicationGatewayRequestRoutingRule.serialize_object(element7)
            end
            serializedArray.push(element7);
          end
          serialized_property = serializedArray;
        end
        output_object['requestRoutingRules'] = serialized_property unless serialized_property.nil?

        serialized_property = object.provisioning_state
        output_object['provisioningState'] = serialized_property unless serialized_property.nil?

        output_object
      end

      #
      # Deserializes given Ruby Hash into Model object.
      # @param object [Hash] Ruby Hash object to deserialize.
      # @return [ApplicationGatewayPropertiesFormat] Deserialized object.
      #
      def self.deserialize_object(object)
        return if object.nil?
        output_object = ApplicationGatewayPropertiesFormat.new

        deserialized_property = object['sku']
        if (deserialized_property)
          deserialized_property = Azure::ARM::Network::Models::ApplicationGatewaySku.deserialize_object(deserialized_property)
        end
        output_object.sku = deserialized_property

        deserialized_property = object['operationalState']
        fail MsRest::DeserializationError.new('Error occured in deserializing the enum', nil, nil, nil) if (!deserialized_property.nil? && !deserialized_property.empty? && !Azure::ARM::Network::ApplicationGatewayOperationalState.constants.any? { |e| Azure::ARM::Network::ApplicationGatewayOperationalState.const_get(e) == deserialized_property })
        output_object.operational_state = deserialized_property

        deserialized_property = object['gatewayIpConfigurations']
        if (deserialized_property)
          deserializedArray = [];
          deserialized_property.each do |element8|
            if (element8)
              element8 = Azure::ARM::Network::Models::ApplicationGatewayIpConfiguration.deserialize_object(element8)
            end
            deserializedArray.push(element8);
          end
          deserialized_property = deserializedArray;
        end
        output_object.gateway_ip_configurations = deserialized_property

        deserialized_property = object['sslCertificates']
        if (deserialized_property)
          deserializedArray = [];
          deserialized_property.each do |element9|
            if (element9)
              element9 = Azure::ARM::Network::Models::ApplicationGatewaySslCertificate.deserialize_object(element9)
            end
            deserializedArray.push(element9);
          end
          deserialized_property = deserializedArray;
        end
        output_object.ssl_certificates = deserialized_property

        deserialized_property = object['frontendIpConfigurations']
        if (deserialized_property)
          deserializedArray = [];
          deserialized_property.each do |element10|
            if (element10)
              element10 = Azure::ARM::Network::Models::ApplicationGatewayFrontendIpConfiguration.deserialize_object(element10)
            end
            deserializedArray.push(element10);
          end
          deserialized_property = deserializedArray;
        end
        output_object.frontend_ip_configurations = deserialized_property

        deserialized_property = object['frontendPorts']
        if (deserialized_property)
          deserializedArray = [];
          deserialized_property.each do |element11|
            if (element11)
              element11 = Azure::ARM::Network::Models::ApplicationGatewayFrontendPort.deserialize_object(element11)
            end
            deserializedArray.push(element11);
          end
          deserialized_property = deserializedArray;
        end
        output_object.frontend_ports = deserialized_property

        deserialized_property = object['backendAddressPools']
        if (deserialized_property)
          deserializedArray = [];
          deserialized_property.each do |element12|
            if (element12)
              element12 = Azure::ARM::Network::Models::ApplicationGatewayBackendAddressPool.deserialize_object(element12)
            end
            deserializedArray.push(element12);
          end
          deserialized_property = deserializedArray;
        end
        output_object.backend_address_pools = deserialized_property

        deserialized_property = object['backendHttpSettingsCollection']
        if (deserialized_property)
          deserializedArray = [];
          deserialized_property.each do |element13|
            if (element13)
              element13 = Azure::ARM::Network::Models::ApplicationGatewayBackendHttpSettings.deserialize_object(element13)
            end
            deserializedArray.push(element13);
          end
          deserialized_property = deserializedArray;
        end
        output_object.backend_http_settings_collection = deserialized_property

        deserialized_property = object['httpListeners']
        if (deserialized_property)
          deserializedArray = [];
          deserialized_property.each do |element14|
            if (element14)
              element14 = Azure::ARM::Network::Models::ApplicationGatewayHttpListener.deserialize_object(element14)
            end
            deserializedArray.push(element14);
          end
          deserialized_property = deserializedArray;
        end
        output_object.http_listeners = deserialized_property

        deserialized_property = object['requestRoutingRules']
        if (deserialized_property)
          deserializedArray = [];
          deserialized_property.each do |element15|
            if (element15)
              element15 = Azure::ARM::Network::Models::ApplicationGatewayRequestRoutingRule.deserialize_object(element15)
            end
            deserializedArray.push(element15);
          end
          deserialized_property = deserializedArray;
        end
        output_object.request_routing_rules = deserialized_property

        deserialized_property = object['provisioningState']
        output_object.provisioning_state = deserialized_property

        output_object.validate

        output_object
      end
    end
  end
end