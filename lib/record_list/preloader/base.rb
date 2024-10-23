# frozen_string_literal: true

module RecordList
  class Preloader
    class Base
      def self.call(reflection, records)
        new(reflection).call(records)
      end

      def call(_records)
        raise NotImplemented
      end

      private

      attr_reader :reflection

      delegate :klass, :name, :attribute, :inverse_name, to: :reflection

      def initialize(reflection)
        @reflection = reflection
      end
    end
  end
end
