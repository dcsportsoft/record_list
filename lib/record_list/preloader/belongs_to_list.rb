# frozen_string_literal: true

module RecordList
  class Preloader
    class BelongsToList < Base
      def call(records)
        ids = ids_for(records)
        result = klass.where.overlap(attribute => ids)

        records.each do |record|
          items = []

          result.each do |item|
            items << item if (item[attribute] || []).include?(record.id)
          end

          record_list = record.record_list(name)
          record_list.target = items.compact_blank
        end
      end

      private

      def ids_for(records)
        record_class = records.first.class
        records.map(&record_class.primary_key.to_sym).compact_blank
      end

      def attribute
        klass_reflection = klass.record_lists_reflections[inverse_name]
        klass_reflection.attribute
      end
    end
  end
end
