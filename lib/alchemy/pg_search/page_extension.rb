# Enable Postgresql full text indexing.
#
Alchemy::Page.class_eval do
  include PgSearch::Model

  after_save :remove_unpublished_pages

  multisearchable(
    against: [
      :meta_description,
      :meta_keywords,
      :name,
    ],
    additional_attributes: -> (page) { { page_id: page.id } },
    if: :searchable?
  )

  def remove_unpublished_pages
    Alchemy::PgSearch::Search.remove_page self unless searchable?
  end

  def searchable?
    public? && !layoutpage?
  end
end
