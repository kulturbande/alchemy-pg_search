# Enable Postgresql full text indexing.
#
Alchemy::Page.class_eval do
  include PgSearch::Model

  multisearchable against: [
    :meta_description,
    :meta_keywords,
    :name,
  ]
end
