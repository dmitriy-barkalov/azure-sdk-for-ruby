# Code generated by Microsoft (R) AutoRest Code Generator 0.10.0.0
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module Azure
  module Models
    #
    # Model object.
    #
    class CustomDomain
      # @return [String] Gets or sets the custom domain name. Name is the
      # CNAME source.
      attr_accessor :name

      # @return [Boolean] Indicates whether indirect CName validation is
      # enabled. Default value is false. This should only be set on updates
      attr_accessor :use_sub_domain

      #
      # Validate the object. Throws ArgumentError if validation fails.
      #
      def validate
        # Nothing to validate
      end

      #
      # Serializes given Model object into Ruby Hash.
      # @param object Model object to serialize.
      # @return [Hash] Serialized object in form of Ruby Hash.
      #
      def self.serialize_object(object)
        object.validate
        output_object = {}

        serialized_property = object.name
        output_object['name'] = serialized_property

        serialized_property = object.use_sub_domain
        output_object['useSubDomain'] = serialized_property
        output_object
      end

      #
      # Deserializes given Ruby Hash into Model object.
      # @param object [Hash] Ruby Hash object to deserialize.
      # @return [CustomDomain] Deserialized object.
      #
      def self.deserialize_object(object)
        return if object.nil?
        output_object = CustomDomain.new

        deserialized_property = object['name']
        output_object.name = deserialized_property

        deserialized_property = object['useSubDomain']
        output_object.use_sub_domain = deserialized_property
        output_object.validate
        output_object
      end
    end
  end
end
