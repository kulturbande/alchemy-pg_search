Alchemy::EssencePicture.class_eval do
  include PgSearch::Model

  multisearchable(
    against: [
      :caption
    ],
    additional_attributes: -> (essence_picture) { { page_id: essence_picture.page.id } },
    if: :searchable?
  )

  def searchable?
    caption.present? && !!content&.searchable?
  end
end
