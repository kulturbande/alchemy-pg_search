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
      # index a single page and indexable essences
      #
      # @param page [Alchemy::Page]
      def self.index_page(page)
        page.update_pg_search_document
        page.contents.all.each do |content|
          content.essence.update_pg_search_document if Alchemy::PgSearch.is_searchable_essence? content.essence_type.sub("Alchemy::", "")
        end
      end

      ##
      # search for page results
      #
      # @param query [string]
      def self.search(query)
        ::PgSearch.multisearch(query).select("JSON_AGG(content) as content", :page_id).reorder("").group(:page_id).joins(:page)
      end

      ##
      # search for pages with the given query
      #
      # @param query [string] the search string
      # @return [array<PageResult>] found page results
      # @deprecated
      def self.search_pages(query)
        results = {}

        raw_search(query).each do |document|
          page = document.searchable_type == "Alchemy::Page" ? document.searchable : document.searchable.page

          next unless page

          results[page.id] = PageResult.new(page) unless results.has_key? page.id
          results[page.id].add_relative_document document
        end

        results.values
      end

      private

      ##
      # @param query [string]
      # @return [array<::PgSearch::Document>]
      # @deprecated
      def self.raw_search(query)
        ::PgSearch.multisearch(query).includes(searchable: { all_elements: { contents: :essence } })
      end
    end
  end
end
