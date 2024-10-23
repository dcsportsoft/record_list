# frozen_string_literal: true

module RecordList
  module Builder
    class Base
      def self.build(model, name, **)
        reflection = create_reflection(name, **)

        define_accessors(model, reflection)
        define_callbacks(model, reflection)

        reflection
      end

      def self.create_reflection(name, **options)
        RecordList::Reflection.new(association, name, **options) if validate_options!(options)
      end

      def self.association
        raise NotImplemented
      end

      def self.validate_options!(options)
        options.assert_valid_keys(valid_options)

        required_options.each do |key|
          raise ArgumentError.new("Key required: #{key}") unless options.key?(key)
        end
      end

      def self.valid_options
        raise NotImplemented
      end

      def self.required_options
        raise NotImplemented
      end

      def self.define_accessors(model, reflection)
        name = reflection.name

        model.class_eval do
          define_method name do
            record_list(name).reader
          end

          define_method :"#{name}=" do |values|
            record_list(name).writer(values)
          end

          define_method :"#{name}_ids" do
            record_list(name).ids_reader
          end

          define_method :"#{name}_ids=" do |values|
            record_list(name).ids_writer(values)
          end
        end
      end

      def self.define_callbacks(model, reflection); end
    end
  end
end
