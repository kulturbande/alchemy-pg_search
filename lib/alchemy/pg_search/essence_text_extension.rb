Alchemy::EssenceText.class_eval do
  include PgSearch::Model

  multisearchable against: [
    :body
  ], if: :searchable?

  def searchable?
    body.present? && content.searchable?
  end
end
