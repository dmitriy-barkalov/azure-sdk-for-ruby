# Code generated by Microsoft (R) AutoRest Code Generator 0.11.0.0
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.


module Azure::ARM::Network
  module Models
    #
    # LocalNetworkGateway properties
    #
    class LocalNetworkGatewayPropertiesFormat

      include MsRestAzure

      # @return [AddressSpace] Local network site Address space
      attr_accessor :local_network_address_space

      # @return [String] IP address of local network gateway.
      attr_accessor :gateway_ip_address

      # @return [String] Gets or sets Provisioning state of the
      # LocalNetworkGateway resource Updating/Deleting/Failed
      attr_accessor :provisioning_state

      #
      # Validate the object. Throws ValidationError if validation fails.
      #
      def validate
        @local_network_address_space.validate unless @local_network_address_space.nil?
      end

      #
      # Serializes given Model object into Ruby Hash.
      # @param object Model object to serialize.
      # @return [Hash] Serialized object in form of Ruby Hash.
      #
      def self.serialize_object(object)
        object.validate
        output_object = {}

        serialized_property = object.local_network_address_space
        unless serialized_property.nil?
          serialized_property = AddressSpace.serialize_object(serialized_property)
        end
        output_object['localNetworkAddressSpace'] = serialized_property unless serialized_property.nil?

        serialized_property = object.gateway_ip_address
        output_object['gatewayIpAddress'] = serialized_property unless serialized_property.nil?

        serialized_property = object.provisioning_state
        output_object['provisioningState'] = serialized_property unless serialized_property.nil?

        output_object
      end

      #
      # Deserializes given Ruby Hash into Model object.
      # @param object [Hash] Ruby Hash object to deserialize.
      # @return [LocalNetworkGatewayPropertiesFormat] Deserialized object.
      #
      def self.deserialize_object(object)
        return if object.nil?
        output_object = LocalNetworkGatewayPropertiesFormat.new

        deserialized_property = object['localNetworkAddressSpace']
        unless deserialized_property.nil?
          deserialized_property = AddressSpace.deserialize_object(deserialized_property)
        end
        output_object.local_network_address_space = deserialized_property

        deserialized_property = object['gatewayIpAddress']
        output_object.gateway_ip_address = deserialized_property

        deserialized_property = object['provisioningState']
        output_object.provisioning_state = deserialized_property

        output_object.validate

        output_object
      end
    end
  end
end