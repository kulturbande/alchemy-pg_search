Alchemy::Element.class_eval do
  include PgSearch::Model

  def searchable?
    public? && page.searchable?
  end
end
