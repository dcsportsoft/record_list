# frozen_string_literal: true

module RecordList
  module Builder
    class BelongsToList < Base
      def self.association
        :belongs_to_list
      end

      def self.valid_options
        %i[class_name inverse_of]
      end

      def self.required_options
        %i[class_name inverse_of]
      end

      def self.define_callbacks(model, reflection)
        model.class_eval do
          after_destroy do
            record_list(reflection.name).clear unless new_record?
          end
        end
      end
    end
  end
end
