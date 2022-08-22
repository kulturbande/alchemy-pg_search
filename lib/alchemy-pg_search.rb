require "alchemy/pg_search/engine"
require "alchemy/pg_search/config"
require "alchemy/pg_search/search"

module Alchemy
  module PgSearch
    SEARCHABLE_ESSENCES = %w[EssenceText EssenceRichtext EssencePicture]

    extend Config

    def self.is_searchable_essence?(essence_type)
      SEARCHABLE_ESSENCES.include?(essence_type)
    end

    def self.searchable_essence_classes
      SEARCHABLE_ESSENCES.map { |k| "Alchemy::#{k.classify}".constantize }
    end
    
    def self.search(query, ability: nil)
      Search.search(query, ability: ability)
    end

    def self.rebuild
      Search.rebuild
    end
  end
end
