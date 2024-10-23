# frozen_string_literal: true

module RecordList
  module Association
    class Base
      attr_reader :owner, :reflection

      delegate :klass, to: :reflection
      delegate :target, :target=, to: :reader

      def initialize(owner, reflection)
        @owner = owner
        @reflection = reflection
      end

      private

      def reset
        @reader = nil
      end

      def types_casting_for(ids)
        type = klass.type_for_attribute(klass.primary_key)

        ids = Array.wrap(ids).compact_blank
        ids.map { |i| type.cast(i) }
      end

      def raise_if_not_found!(ids)
        ids = types_casting_for(ids)

        found_ids = klass.where(klass.primary_key => ids).pluck(klass.primary_key)
        return if found_ids.size == ids.size

        error = "Couldn't find #{klass.name} with ids in #{ids - found_ids}"
        raise ::ActiveRecord::RecordNotFound.new(error, klass.name, klass.primary_key, ids - found_ids)
      end

      def raise_if_type_mismatch!(record)
        return if record.is_a?(klass)

        message = "#{klass.name} expected, got #{record.inspect} which is an instance of #{record.class}"
        raise ::ActiveRecord::AssociationTypeMismatch, message
      end

      def raise_if_not_persisted!(record)
        return if record.persisted?

        raise ::ActiveRecord::RecordNotSaved, "#{record.inspect} not persisted"
      end
    end
  end
end
