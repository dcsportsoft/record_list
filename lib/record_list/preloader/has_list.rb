# frozen_string_literal: true

module RecordList
  class Preloader
    class HasList < Base
      def call(records)
        ids = ids_for(records)
        result = klass.where(klass.primary_key => ids).index_by(&klass.primary_key.to_sym)

        records.each do |record|
          record_list = record.record_list(name)
          record_list.target = result.values_at(*record[attribute]).compact_blank
        end
      end

      private

      def ids_for(records)
        ids = records.flat_map { |record| record[attribute] }.uniq
        Array.wrap(ids).compact_blank
      end
    end
  end
end
