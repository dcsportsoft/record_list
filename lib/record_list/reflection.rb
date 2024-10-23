# frozen_string_literal: true

module RecordList
  class Reflection
    attr_reader :association, :name, :options

    def initialize(association, name, **options)
      @association = association
      @name = name
      @options = options
    end

    def association_class
      case association
      when :has_list
        RecordList::Association::HasList
      when :belongs_to_list
        RecordList::Association::BelongsToList
      end
    end

    def klass
      @klass ||= class_name.classify.constantize
    end

    def attribute
      options[:attribute] || name.to_s
    end

    def class_name
      options[:class_name] || name.to_s
    end

    def inverse_name
      options[:inverse_of]
    end
  end
end
