Alchemy::EssenceRichtext.class_eval do
  include PgSearch::Model

  multisearchable against: [
    :stripped_body
  ], if: :searchable?

  def searchable?
    stripped_body.present? && !!content&.searchable?
  end
end
