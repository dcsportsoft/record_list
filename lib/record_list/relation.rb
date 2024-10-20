# frozen_string_literal: true

module RecordList
  class Relation
    class << self
      def build(klass, record_list, **)
        relation_class = klass.all.class

        wrapper_class = Class.new(relation_class)
        wrapper_class.include(Extension)

        wrapper_class.new(klass, record_list, **)
      end
    end
  end
end
