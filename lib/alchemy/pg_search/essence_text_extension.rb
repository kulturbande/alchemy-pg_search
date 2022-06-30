Alchemy::EssenceText.class_eval do
  include PgSearch::Model

  multisearchable against: [
    :body
  ], if: lambda { |record| !record.body.nil? && !record.body.empty? }
end
