module Alchemy::PgSearch::ContentExtension
  module ClassMethods
    def new(attributes)
      super.tap do |content|
        content.searchable = content.definition.key?(:searchable) ? content.definition[:searchable] : true
      end
    end

    Alchemy::Content.singleton_class.prepend self
  end

  module InstanceMethods
    ##
    # @deprecated
    def searchable_ingredient
      case essence_type
      when "Alchemy::EssencePicture"
        essence.caption
      when "Alchemy::EssenceRichtext"
        essence.stripped_body
      when "Alchemy::EssenceText"
        essence.body
      else
        ingredient
      end
    end

    def searchable?
      searchable && element.searchable?
    end

    Alchemy::Content.prepend self
  end
end
