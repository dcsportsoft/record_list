# frozen_string_literal: true

require "rails"
require "active_record_extended"

require_relative "record_list/version"
require_relative "record_list/methods/core"
require_relative "record_list/methods/common"
require_relative "record_list/methods/reflection"
require_relative "record_list/builder/base"
require_relative "record_list/builder/has_list"
require_relative "record_list/builder/belongs_to_list"
require_relative "record_list/association/base"
require_relative "record_list/association/has_list"
require_relative "record_list/association/belongs_to_list"
require_relative "record_list/reflection"
require_relative "record_list/preloader/base"
require_relative "record_list/preloader/has_list"
require_relative "record_list/preloader/belongs_to_list"
require_relative "record_list/preloader"
require_relative "record_list/relation/extension"
require_relative "record_list/relation"
require_relative "record_list/test/matchers"

module RecordList
  extend ActiveSupport::Concern

  included do
    include Methods::Core
    include Methods::Common
  end

  module ClassMethods
    include Methods::Reflection

    def record_list(name, **)
      reflection = RecordList::Builder::HasList.build(self, name, **)
      record_lists_reflections_cache[name] ||= reflection
    end

    # rubocop:disable Naming/PredicateName
    def has_and_belongs_to_record_lists(name, **)
      reflection = RecordList::Builder::BelongsToList.build(self, name, **)
      record_lists_reflections_cache[name] ||= reflection
    end
    # rubocop:enable Naming/PredicateName
  end
end
