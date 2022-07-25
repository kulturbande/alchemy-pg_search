module Alchemy
  module PgSearch
    ##
    # @deprecated
    class PageSearchScope
      ##
      # @deprecated
      def pages
        Alchemy::Page.published.contentpages.with_language(Alchemy::Language.current.id)
      end
    end
  end
end
