module Alchemy
  module PgSearch
    module Search

      ##
      # index all supported Alchemy models
      def self.rebuild
        [Alchemy::Page, Alchemy::EssenceText, Alchemy::EssenceRichtext, Alchemy::EssencePicture].each do |model|
          ::PgSearch::Multisearch.rebuild(model)
        end
      end

      ##
      # remove the whole index for the page
      #
      # @param page [Alchemy::Page]
      def self.remove_page(page)
        ::PgSearch::Document.delete_by(page_id: page.id)
      end

      ##
      # index a single page and indexable essences
      #
      # @param page [Alchemy::Page]
      def self.index_page(page)
        remove_page page

        page.update_pg_search_document
        page.all_elements.includes(contents: :essence).each do |element|
          element.contents.each do |content|
            content.essence.update_pg_search_document if Alchemy::PgSearch.is_searchable_essence? content.essence_type.sub("Alchemy::", "")
          end
        end
      end

      ##
      # search for page results
      #
      # @param query [string]
      # @param ability [nil|CanCan::Ability]
      # @return [ActiveRecord::Relation]
      def self.search(query, ability: nil)
        query = ::PgSearch.multisearch(query)
                  .select("JSON_AGG(content) as content", :page_id)
                  .reorder("")
                  .group(:page_id)
                  .joins(:page)

        query = query.merge(Alchemy::Page.accessible_by(ability, :read)) if ability

        query
      end
    end
  end
end
