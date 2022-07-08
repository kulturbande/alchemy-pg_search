module Alchemy
  module PgSearch
    class PageResult
      attr_reader :page
      attr_accessor :relative_documents

      ##
      # @param page [Alchemy::Page]
      def initialize(page)
        @page = page
        @relative_documents = []
      end

      ##
      # add a search document which is connected to the page
      # @param pg_document [::PgSearch::Document]
      def add_relative_document(pg_document)
        @relative_documents.push pg_document
      end

      ##
      # content of the first document
      # @return [String, nil]
      def first_excerpt
        relative_documents.first&.content
      end
    end
  end
end
