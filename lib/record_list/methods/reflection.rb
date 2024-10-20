# frozen_string_literal: true

module RecordList
  module Methods
    module Reflection
      def record_lists_reflections
        reflections = record_lists_reflections_cache

        if superclass.respond_to?(:record_lists_reflections)
          reflections = reflections.merge(superclass.record_lists_reflections)
        end

        reflections.clone(freeze: true)
      end

      private

      def record_lists_reflections_cache
        @record_lists_reflections_cache ||= {}
      end
    end
  end
end
