require "alchemy/pg_search/engine"
require "alchemy/pg_search/config"
require "alchemy/pg_search/search"
require "alchemy/pg_search/page_result"
require "alchemy/pg_search/page_search_scope"

module Alchemy
  module PgSearch
    SEARCHABLE_ESSENCES = %w[EssenceText EssenceRichtext EssencePicture]
    DEFAULT_CONFIG = {
      page_search_scope: PageSearchScope.new,
    }

    extend Config
    self.config = DEFAULT_CONFIG

    def self.is_searchable_essence?(essence_type)
      SEARCHABLE_ESSENCES.include?(essence_type)
    end

    def self.searchable_essence_classes
      SEARCHABLE_ESSENCES.map { |k| "Alchemy::#{k.classify}".constantize }
    end
    
    def self.search_pages(query)
      Search.search_pages query
    end

    def self.index_alchemy
      Search.index_alchemy
    end
  end
end
