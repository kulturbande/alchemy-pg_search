module Alchemy
  module PgSearch
    module Search

      ##
      # index all supported Alchemy models
      def self.index_alchemy
        [Alchemy::Page, Alchemy::EssenceText].each { |model| ::PgSearch::Multisearch.rebuild(model) }
      end

      ##
      # search for pages with the given query
      #
      # @param query [string] the search string
      # @return [array<PageResult>] found page results
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
      def self.raw_search(query)
        ::PgSearch.multisearch(query).includes(searchable: {all_elements: {contents: :essence}})
      end
    end
  end
end
