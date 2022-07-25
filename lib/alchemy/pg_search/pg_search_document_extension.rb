PgSearch::Document.class_eval do
  belongs_to :page, class_name: "::Alchemy::Page", foreign_key: "page_id"

  ##
  # get a list of excerpts of the searched phrase
  # @return [array<string>]
  def excerpts
    begin
      JSON.parse content
    rescue JSON::ParserError
      []
    end
  end
end
