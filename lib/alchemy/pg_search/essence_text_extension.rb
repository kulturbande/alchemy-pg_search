Alchemy::EssenceText.class_eval do
  include PgSearch::Model

  multisearchable against: [
    :body
  ], if: lambda { |record| record.page.public? && !record.page.restricted? && record.element&.public? && record.body.present? }
end
