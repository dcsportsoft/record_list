# frozen_string_literal: true

module RecordList
  module Test
    module Matchers
      class HaveRecordList
        def initialize(expected)
          @expected = expected
          @options = {}
        end

        def matches?(actual)
          @actual = actual
          instance_class? && class_name? && inverse_of?
        end

        def class_name(class_name)
          @options[:class_name] = class_name
          self
        end

        def inverse_of(inverse_of)
          @options[:inverse_of] = inverse_of
          self
        end

        def failure_message
          %(expected #{@actual.inspect} to have record list "#{@expected}", but they were not)
        end

        def failure_message_when_negated
          %(expected #{@actual.inspect} not to have record list "#{@expected}", but it did)
        end

        def description
          %(have record list "#{@expected}")
        end

        def instance
          @instance ||= @actual.record_list(@expected)
        end

        def instance_class?
          instance.is_a?(RecordList::Association::HasList)
        end

        def class_name?
          if @options[:class_name]
            instance.reflection.class_name == @options[:class_name]
          else
            true
          end
        end

        def inverse_of?
          if @options[:inverse_of]
            instance.reflection.inverse_name == @options[:inverse_of]
          else
            true
          end
        end
      end

      def have_record_list(expected)
        HaveRecordList.new(expected)
      end

      class HaveAndBelongsToRecordLists
        def initialize(expected)
          @expected = expected
          @options = {}
        end

        def matches?(actual)
          @actual = actual
          instance_class? && class_name? && inverse_of? && attribute?
        end

        def class_name(class_name)
          @options[:class_name] = class_name
          self
        end

        def inverse_of(inverse_of)
          @options[:inverse_of] = inverse_of
          self
        end

        def attribute(attribute)
          @options[:attribute] = attribute
          self
        end

        def failure_message
          %(expected #{@actual.inspect} to have and belongs to record lists "#{@expected}", but they were not)
        end

        def failure_message_when_negated
          %(expected #{@actual.inspect} not to have and belongs to record lists "#{@expected}", but it did)
        end

        def description
          %(have and belongs to record lists "#{@expected}")
        end

        def instance
          @instance ||= @actual.record_list(@expected)
        end

        def instance_class?
          instance.is_a?(RecordList::Association::BelongsToList)
        end

        def class_name?
          if @options[:class_name]
            instance.reflection.class_name == @options[:class_name]
          else
            true
          end
        end

        def inverse_of?
          if @options[:inverse_of]
            instance.reflection.inverse_name == @options[:inverse_of]
          else
            true
          end
        end

        def attribute?
          if @options[:attribute]
            instance.reflection.attribute == @options[:attribute]
          else
            true
          end
        end
      end

      def have_and_belongs_to_record_lists(expected)
        HaveAndBelongsToRecordLists.new(expected)
      end
    end
  end
end
