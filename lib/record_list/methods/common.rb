# frozen_string_literal: true

module RecordList
  module Methods
    module Common
      def record_list(name)
        @record_lists_cache[name] ||= create_record_list!(name)
      end

      private

      def create_record_list!(name)
        reflection = self.class.record_lists_reflections[name]
        raise StandardError, %(Record list reflection "#{name}" not found) if reflection.blank?

        reflection.association_class.new(self, reflection)
      end
    end
  end
end
