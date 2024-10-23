# frozen_string_literal: true

module RecordList
  module Methods
    module Core
      def initialize_dup(*)
        @record_lists_cache = {}
        super
      end

      def reload(*)
        @record_lists_cache = {}
        super
      end

      private

      def init_internals
        @record_lists_cache = {}
        super
      end
    end
  end
end
