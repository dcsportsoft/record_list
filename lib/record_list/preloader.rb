# frozen_string_literal: true

module RecordList
  class Preloader
    def self.call(records, lists)
      records = Array.wrap(records).compact_blank
      return [] if records.empty?

      Array.wrap(lists).each do |list|
        record_class = records.first.class

        reflection = record_class.record_lists_reflections[list.to_sym]
        next unless reflection

        case reflection.association
        when :has_list
          RecordList::Preloader::HasList.call(reflection, records)
        when :belongs_to_list
          RecordList::Preloader::BelongsToList.call(reflection, records)
        end
      end

      records
    end
  end
end
