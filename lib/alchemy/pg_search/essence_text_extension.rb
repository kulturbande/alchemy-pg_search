Alchemy::EssenceText.class_eval do
  include PgSearch::Model

  multisearchable(
    against: [
      :body
    ],
    additional_attributes: -> (essence_text) { { page_id: essence_text.page.id } },
    if: :searchable?
  )

  def searchable?
    body.present? && !!content&.searchable?
  end
end
