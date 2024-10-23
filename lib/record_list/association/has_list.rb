# frozen_string_literal: true

module RecordList
  module Association
    class HasList < Base
      delegate :attribute, to: :reflection

      def ids_reader
        reader.pluck(klass.primary_key)
      end

      def ids_writer(ids)
        ids = Array.wrap(ids).compact_blank
        raise_if_not_found!(ids)

        reset
        self.ids = ids

        ids_reader
      end

      def reader
        @reader ||= build_scope(ids)
      end

      def writer(records)
        records = Array.wrap(records).compact_blank
        records.each { |record| raise_if_type_mismatch!(record) || raise_if_not_persisted!(record) }

        ids = records.pluck(klass.primary_key)
        ids_writer(ids)

        reader
      end

      def <<(records)
        records = Array.wrap(records).compact_blank
        records.each { |record| raise_if_type_mismatch!(record) || raise_if_not_persisted!(record) }

        ids = records.pluck(klass.primary_key)
        raise_if_not_found!(ids)

        reset
        ids.each { |id| self.ids << id }

        reader
      end

      def clear
        owner[attribute] = []
      end

      private

      def build_scope(ids)
        scope = RecordList::Relation.build(klass, self)
        scope.where(klass.primary_key => ids)
      end

      def ids
        owner[attribute]
      end

      def ids=(ids)
        ids = Array.wrap(ids).compact_blank
        owner[attribute] = ids
      end
    end
  end
end
