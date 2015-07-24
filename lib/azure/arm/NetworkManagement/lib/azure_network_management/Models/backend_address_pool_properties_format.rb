# Code generated by Microsoft (R) AutoRest Code Generator 0.11.0.0
# Changes may cause incorrect behavior and will be lost if the code is


module Azure::ARM::Network
  module Models
    #
    # Properties of BackendAddressPool
    #
    class BackendAddressPoolPropertiesFormat
      # @return [Array<SubResource>] Gets collection of references to IPs
      # defined in NICs
      attr_accessor :backend_ipconfigurations

      # @return [Array<SubResource>] Gets Load Balancing rules that use this
      # Backend Address Pool
      attr_accessor :load_balancing_rules

      # @return [String] Provisioning state of the PublicIP resource
      # Updating/Deleting/Failed
      attr_accessor :provisioning_state

      def initialize
        @backend_ipconfigurations = [];
        @load_balancing_rules = [];
      end

      #
      # Validate the object. Throws ArgumentError if validation fails.
      #
      def validate
        @backend_ipconfigurations.each{ |e| e.validate if e.respond_to?(:validate) } unless @backend_ipconfigurations.nil?
        @load_balancing_rules.each{ |e| e.validate if e.respond_to?(:validate) } unless @load_balancing_rules.nil?
      end

      #
      # Serializes given Model object into Ruby Hash.
      # @param object Model object to serialize.
      # @return [Hash] Serialized object in form of Ruby Hash.
      #
      def self.serialize_object(object)
        object.validate
        output_object = {}

        serialized_property = object.backend_ipconfigurations
        if (serialized_property)
          serializedArray = [];
          serialized_property.each do |element|
            if (element)
              element = Azure::ARM::Network::Models::SubResource.serialize_object(element)
            end
            serializedArray.push(element);
          end
          serialized_property = serializedArray;
        end
        output_object['backendIPConfigurations'] = serialized_property unless serialized_property.nil?

        serialized_property = object.load_balancing_rules
        if (serialized_property)
          serializedArray = [];
          serialized_property.each do |element1|
            if (element1)
              element1 = Azure::ARM::Network::Models::SubResource.serialize_object(element1)
            end
            serializedArray.push(element1);
          end
          serialized_property = serializedArray;
        end
        output_object['loadBalancingRules'] = serialized_property unless serialized_property.nil?

        serialized_property = object.provisioning_state
        output_object['provisioningState'] = serialized_property unless serialized_property.nil?

        output_object
      end

      #
      # Deserializes given Ruby Hash into Model object.
      # @param object [Hash] Ruby Hash object to deserialize.
      # @return [BackendAddressPoolPropertiesFormat] Deserialized object.
      #
      def self.deserialize_object(object)
        return if object.nil?
        output_object = BackendAddressPoolPropertiesFormat.new

        deserialized_property = object['backendIPConfigurations']
        if (deserialized_property)
          deserializedArray = [];
          deserialized_property.each do |element2|
            if (element2)
              element2 = Azure::ARM::Network::Models::SubResource.deserialize_object(element2)
            end
            deserializedArray.push(element2);
          end
          deserialized_property = deserializedArray;
        end
        output_object.backend_ipconfigurations = deserialized_property

        deserialized_property = object['loadBalancingRules']
        if (deserialized_property)
          deserializedArray = [];
          deserialized_property.each do |element3|
            if (element3)
              element3 = Azure::ARM::Network::Models::SubResource.deserialize_object(element3)
            end
            deserializedArray.push(element3);
          end
          deserialized_property = deserializedArray;
        end
        output_object.load_balancing_rules = deserialized_property

        deserialized_property = object['provisioningState']
        output_object.provisioning_state = deserialized_property

        output_object.validate

        output_object
      end
    end
  end
end