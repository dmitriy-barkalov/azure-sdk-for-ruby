# Code generated by Microsoft (R) AutoRest Code Generator 0.11.0.0
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.


module Azure::ARM::Compute
  module Models
    #
    # Contains the os disk image information.
    #
    class OSDiskImage

      include MsRestAzure

      # @return [OperatingSystemTypes] Gets or sets the operating system of
      # the osDiskImage. Possible values for this property include:
      # 'Windows', 'Linux'.
      attr_accessor :operating_system

      #
      # Validate the object. Throws ValidationError if validation fails.
      #
      def validate
      end

      #
      # Serializes given Model object into Ruby Hash.
      # @param object Model object to serialize.
      # @return [Hash] Serialized object in form of Ruby Hash.
      #
      def self.serialize_object(object)
        object.validate
        output_object = {}

        serialized_property = object.operating_system
        output_object['operatingSystem'] = serialized_property unless serialized_property.nil?

        output_object
      end

      #
      # Deserializes given Ruby Hash into Model object.
      # @param object [Hash] Ruby Hash object to deserialize.
      # @return [OSDiskImage] Deserialized object.
      #
      def self.deserialize_object(object)
        return if object.nil?
        output_object = OSDiskImage.new

        deserialized_property = object['operatingSystem']
        if (!deserialized_property.nil? && !deserialized_property.empty?)
          enum_is_valid = OperatingSystemTypes.constants.any? { |e| OperatingSystemTypes.const_get(e).to_s.downcase == deserialized_property.downcase }
          fail MsRest::DeserializationError.new('Error occured while deserializing the enum', nil, nil, nil) unless enum_is_valid
        end
        output_object.operating_system = deserialized_property

        output_object.validate

        output_object
      end
    end
  end
end