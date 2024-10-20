# frozen_string_literal: true

module RecordList
  module Association
    class BelongsToList < Base
      delegate :inverse_name, to: :reflection

      def ids_reader
        reader.pluck(klass.primary_key)
      end

      def ids_writer(ids)
        raise_if_not_persisted!(owner)

        ids = Array.wrap(ids).compact_blank
        raise_if_not_found!(ids)

        self.foreign_ids = ids
        reset

        ids_reader
      end

      def reader
        @reader ||= build_scope
      end

      def writer(records)
        raise_if_not_persisted!(owner)

        records = Array.wrap(records).compact_blank
        records.each { |record| raise_if_type_mismatch!(record) || raise_if_not_persisted!(record) }

        ids = records.pluck(klass.primary_key)
        ids_writer(ids)

        reader
      end

      def <<(records)
        raise_if_not_persisted!(owner)

        records = Array.wrap(records).compact_blank
        records.each { |record| raise_if_type_mismatch!(record) || raise_if_not_persisted!(record) }

        ids = records.pluck(klass.primary_key)
        raise_if_not_found!(ids)

        attr = klass.arel_table[attribute]
        klass.where(klass.primary_key => ids).update_all("#{attr.name} = array_append(#{attr.name}, #{id})")
        reset

        reader
      end

      def clear
        attr = klass.arel_table[attribute]

        build_scope.update_all("#{attr.name} = array_remove(#{attr.name}, #{id})")
      end

      private

      def build_scope
        scope = RecordList::Relation.build(klass, self)
        scope.where.overlap(attribute => Array.wrap(id).compact_blank)
      end

      def attribute
        klass_reflection = klass.record_lists_reflections[inverse_name]
        klass_reflection.attribute
      end

      def id
        owner.public_send(owner.class.primary_key)
      end

      def foreign_ids=(ids)
        ids = Array.wrap(ids).compact_blank
        attr = klass.arel_table[attribute]

        klass.transaction do
          build_scope.update_all("#{attr.name} = array_remove(#{attr.name}, #{id})")
          klass.where(klass.primary_key => ids).update_all("#{attr.name} = array_append(#{attr.name}, #{id})")
        end
      end
    end
  end
end
