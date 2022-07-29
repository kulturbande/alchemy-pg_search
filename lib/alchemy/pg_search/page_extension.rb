# Enable Postgresql full text indexing.
#
Alchemy::Page.class_eval do
  include PgSearch::Model

  multisearchable(
    against: [
      :meta_description,
      :meta_keywords,
      :name,
    ],
    additional_attributes: -> (page) { { page_id: page.id } },
    if: :searchable?
  )

  def searchable?
    public? && !restricted? && !layoutpage?
  end
end
