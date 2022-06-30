module Alchemy
  module PgSearch
    module Search

      def self.index_alchemy
        ::PgSearch::Multisearch.rebuild(Alchemy::Page)
        ::PgSearch::Multisearch.rebuild(Alchemy::EssenceText)
      end

      def self.search_pages(query)
        ::PgSearch.multisearch(query) #.include(:searchable)
      end
    end
  end
end
