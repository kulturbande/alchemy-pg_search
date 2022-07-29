Alchemy::Element.class_eval do

  def searchable?
    public? && page.searchable? && page_version.public?
  end
end
