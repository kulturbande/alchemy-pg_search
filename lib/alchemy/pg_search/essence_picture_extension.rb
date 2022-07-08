Alchemy::EssencePicture.class_eval do
  include PgSearch::Model

  multisearchable against: [
    :caption
  ], if: :searchable?

  def searchable?
    caption.present? && !!content&.searchable?
  end
end
