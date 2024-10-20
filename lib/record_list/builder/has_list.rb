# frozen_string_literal: true

module RecordList
  module Builder
    class HasList < Base
      def self.association
        :has_list
      end

      def self.valid_options
        %i[class_name inverse_of attribute]
      end

      def self.required_options
        %i[class_name]
      end
    end
  end
end
