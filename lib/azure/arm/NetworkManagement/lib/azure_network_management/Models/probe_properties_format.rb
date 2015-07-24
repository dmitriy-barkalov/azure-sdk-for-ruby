# Code generated by Microsoft (R) AutoRest Code Generator 0.11.0.0
# Changes may cause incorrect behavior and will be lost if the code is


module Azure::ARM::Network
  module Models
    #
    # Model object.
    #
    class ProbePropertiesFormat
      # @return [Array<SubResource>] Gets Load balancer rules that use this
      # probe
      attr_accessor :load_balancing_rules

      # @return Gets or sets the protocol of the end point. Possible values
      # are http pr Tcp. If Tcp is specified, a received ACK is required for
      # the probe to be successful. If http is specified,a 200 OK response
      # from the specifies URI is required for the probe to be successful.
      # Possible values for this property include: 'Http', 'Tcp'
      attr_accessor :protocol

      # @return [Integer] Gets or sets Port for communicating the probe.
      # Possible values range from 1 to 65535, inclusive.
      attr_accessor :port

      # @return [Integer] Gets or sets the interval, in seconds, for how
      # frequently to probe the endpoint for health status. Typically, the
      # interval is slightly less than half the allocated timeout period (in
      # seconds) which allows two full probes before taking the instance out
      # of rotation. The default value is 15, the minimum value is 5
      attr_accessor :interval_in_seconds

      # @return [Integer] Gets or sets the number of probes where if no
      # response, will result in stopping further traffic from being
      # delivered to the endpoint. This values allows endponints to be taken
      # out of rotation faster or slower than the typical times used in
      # Azure.
      attr_accessor :number_of_probes

      # @return [String] Gets or sets the URI used for requesting health
      # status from the VM. Path is required if a protocol is set to http.
      # Otherwise, it is not allowed. There is no default value
      attr_accessor :request_path

      # @return [String] Gets or sets Provisioning state of the PublicIP
      # resource Updating/Deleting/Failed
      attr_accessor :provisioning_state

      def initialize
        @load_balancing_rules = [];
      end

      #
      # Validate the object. Throws ArgumentError if validation fails.
      #
      def validate
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

        serialized_property = object.load_balancing_rules
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
        output_object['loadBalancingRules'] = serialized_property unless serialized_property.nil?

        serialized_property = object.protocol
        output_object['protocol'] = serialized_property unless serialized_property.nil?

        serialized_property = object.port
        output_object['port'] = serialized_property unless serialized_property.nil?

        serialized_property = object.interval_in_seconds
        output_object['intervalInSeconds'] = serialized_property unless serialized_property.nil?

        serialized_property = object.number_of_probes
        output_object['numberOfProbes'] = serialized_property unless serialized_property.nil?

        serialized_property = object.request_path
        output_object['requestPath'] = serialized_property unless serialized_property.nil?

        serialized_property = object.provisioning_state
        output_object['provisioningState'] = serialized_property unless serialized_property.nil?

        output_object
      end

      #
      # Deserializes given Ruby Hash into Model object.
      # @param object [Hash] Ruby Hash object to deserialize.
      # @return [ProbePropertiesFormat] Deserialized object.
      #
      def self.deserialize_object(object)
        return if object.nil?
        output_object = ProbePropertiesFormat.new

        deserialized_property = object['loadBalancingRules']
        if (deserialized_property)
          deserializedArray = [];
          deserialized_property.each do |element1|
            if (element1)
              element1 = Azure::ARM::Network::Models::SubResource.deserialize_object(element1)
            end
            deserializedArray.push(element1);
          end
          deserialized_property = deserializedArray;
        end
        output_object.load_balancing_rules = deserialized_property

        deserialized_property = object['protocol']
        fail MsRest::DeserializationError.new('Error occured in deserializing the enum', nil, nil, nil) if (!deserialized_property.nil? && !deserialized_property.empty? && !Azure::ARM::Network::ProbeProtocol.constants.any? { |e| Azure::ARM::Network::ProbeProtocol.const_get(e) == deserialized_property })
        output_object.protocol = deserialized_property

        deserialized_property = object['port']
        deserialized_property = Integer(deserialized_property) unless deserialized_property.to_s.empty?
        output_object.port = deserialized_property

        deserialized_property = object['intervalInSeconds']
        deserialized_property = Integer(deserialized_property) unless deserialized_property.to_s.empty?
        output_object.interval_in_seconds = deserialized_property

        deserialized_property = object['numberOfProbes']
        deserialized_property = Integer(deserialized_property) unless deserialized_property.to_s.empty?
        output_object.number_of_probes = deserialized_property

        deserialized_property = object['requestPath']
        output_object.request_path = deserialized_property

        deserialized_property = object['provisioningState']
        output_object.provisioning_state = deserialized_property

        output_object.validate

        output_object
      end
    end
  end
end