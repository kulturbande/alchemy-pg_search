# Enable Postgresql full text indexing.
#
Alchemy::Page.class_eval do
  include PgSearch::Model

  multisearchable against: [
    :meta_description,
    :meta_keywords,
    :title,
    :name,
  ]

  def self.full_text_search(query)
    PgSearch.multisearch(query).where(searchable_type: "Alchemy::Page").map { |document| document.searchable }
  end
end


# module Alchemy::PgSearch::PageExtension
#   def self.extended(base)
#     base.include InstanceMethods
#     base.include PgSearch::Model
#
#     base.multisearchable against: [
#       :meta_description,
#       :meta_keywords,
#       :title,
#       :name,
#     ]

      # associated_against: {
      #   searchable_essence_texts: :body,
      #   searchable_essence_richtexts: :stripped_body,
      #   searchable_essence_pictures: :caption,
      # },
      # using: {
      #   tsearch: { prefix: true },
      # },

    # base.has_many(
    #   :searchable_contents,
    #   -> { where(searchable: true) },
    #   class_name: "Alchemy::Content",
    #   through: :all_elements,
    # )
    #
    # Alchemy::PgSearch::SEARCHABLE_ESSENCES.each do |klass|


      # base.has_many(
      #   :"searchable_#{klass.underscore.pluralize}",
      #   class_name: "Alchemy::#{klass}",
      #   source_type: "Alchemy::#{klass}",
      #   through: :searchable_contents,
      #   source: :essence,
      # )
#     end
#   end
#
#   module InstanceMethods
#     def element_search_results(query)
#       # all_elements.full_text_search(query)
#     end
#
#     def self.foo
#       puts "foo"
#     end
#   end
#
#   Alchemy::Page.extend self
# end
