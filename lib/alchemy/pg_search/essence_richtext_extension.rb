Alchemy::EssenceRichtext.class_eval do
  include PgSearch::Model

  multisearchable(
    against: [
      :stripped_body
    ],
    additional_attributes: -> (essence_richtext) { { page_id: essence_richtext.page.id } },
    if: :searchable?
  )

  def searchable?
    stripped_body.present? && !!content&.searchable?
  end
end
