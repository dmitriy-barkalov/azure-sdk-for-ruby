# Code generated by Microsoft (R) AutoRest Code Generator 0.11.0.0
# Changes may cause incorrect behavior and will be lost if the code is


module Azure::ARM::Compute
  module Models
    #
    # Describes a data disk.
    #
    class DataDisk
      # @return [Integer] Gets or sets the logical unit number.
      attr_accessor :lun

      # @return [Integer] Gets or sets the disk size in GB for a blank data
      # disk to be created.
      attr_accessor :disk_size_gb

      # @return [String] Gets or sets the disk name.
      attr_accessor :name

      # @return [VirtualHardDisk] Gets or sets the Virtual Hard Disk.
      attr_accessor :vhd

      # @return [VirtualHardDisk] Gets or sets the Source User Image
      # VirtualHardDisk. This VirtualHardDisk will be copied before using it
      # to attach to the Virtual Machine.If SourceImage is provided, the
      # destination VirtualHardDisk should not exist.
      attr_accessor :image

      # @return Gets or sets the caching type. Possible values for this
      # property include: 'None', 'ReadOnly', 'ReadWrite'
      attr_accessor :caching

      # @return Gets or sets the create option. Possible values for this
      # property include: 'fromImage', 'empty', 'attach'
      attr_accessor :create_option

      #
      # Validate the object. Throws ArgumentError if validation fails.
      #
      def validate
        @vhd.validate unless @vhd.nil?
        @image.validate unless @image.nil?
      end

      #
      # Serializes given Model object into Ruby Hash.
      # @param object Model object to serialize.
      # @return [Hash] Serialized object in form of Ruby Hash.
      #
      def self.serialize_object(object)
        object.validate
        output_object = {}

        serialized_property = object.lun
        output_object['lun'] = serialized_property unless serialized_property.nil?

        serialized_property = object.disk_size_gb
        output_object['diskSizeGB'] = serialized_property unless serialized_property.nil?

        serialized_property = object.name
        output_object['name'] = serialized_property unless serialized_property.nil?

        serialized_property = object.vhd
        if (serialized_property)
          serialized_property = Azure::ARM::Compute::Models::VirtualHardDisk.serialize_object(serialized_property)
        end
        output_object['vhd'] = serialized_property unless serialized_property.nil?

        serialized_property = object.image
        if (serialized_property)
          serialized_property = Azure::ARM::Compute::Models::VirtualHardDisk.serialize_object(serialized_property)
        end
        output_object['image'] = serialized_property unless serialized_property.nil?

        serialized_property = object.caching
        output_object['caching'] = serialized_property unless serialized_property.nil?

        serialized_property = object.create_option
        output_object['createOption'] = serialized_property unless serialized_property.nil?

        output_object
      end

      #
      # Deserializes given Ruby Hash into Model object.
      # @param object [Hash] Ruby Hash object to deserialize.
      # @return [DataDisk] Deserialized object.
      #
      def self.deserialize_object(object)
        return if object.nil?
        output_object = DataDisk.new

        deserialized_property = object['lun']
        deserialized_property = Integer(deserialized_property) unless deserialized_property.to_s.empty?
        output_object.lun = deserialized_property

        deserialized_property = object['diskSizeGB']
        deserialized_property = Integer(deserialized_property) unless deserialized_property.to_s.empty?
        output_object.disk_size_gb = deserialized_property

        deserialized_property = object['name']
        output_object.name = deserialized_property

        deserialized_property = object['vhd']
        if (deserialized_property)
          deserialized_property = Azure::ARM::Compute::Models::VirtualHardDisk.deserialize_object(deserialized_property)
        end
        output_object.vhd = deserialized_property

        deserialized_property = object['image']
        if (deserialized_property)
          deserialized_property = Azure::ARM::Compute::Models::VirtualHardDisk.deserialize_object(deserialized_property)
        end
        output_object.image = deserialized_property

        deserialized_property = object['caching']
        fail MsRest::DeserializationError.new('Error occured in deserializing the enum', nil, nil, nil) if (!deserialized_property.nil? && !deserialized_property.empty? && !Azure::ARM::Compute::CachingTypes.constants.any? { |e| Azure::ARM::Compute::CachingTypes.const_get(e) == deserialized_property })
        output_object.caching = deserialized_property

        deserialized_property = object['createOption']
        fail MsRest::DeserializationError.new('Error occured in deserializing the enum', nil, nil, nil) if (!deserialized_property.nil? && !deserialized_property.empty? && !Azure::ARM::Compute::DiskCreateOptionTypes.constants.any? { |e| Azure::ARM::Compute::DiskCreateOptionTypes.const_get(e) == deserialized_property })
        output_object.create_option = deserialized_property

        output_object.validate

        output_object
      end
    end
  end
end