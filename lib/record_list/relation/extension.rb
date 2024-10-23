# frozen_string_literal: true

module RecordList
  class Relation
    module Extension
      extend ActiveSupport::Concern

      included do
        def initialize(klass, record_list, **options)
          super(klass, **options)
          @record_list = record_list
        end

        alias_method :target, :records

        def target=(records)
          load_records(records)
        end

        def <<(records)
          @record_list << records
        end
      end
    end
  end
end
