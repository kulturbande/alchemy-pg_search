PgSearch::Document.class_eval do
  belongs_to :page, class_name: "::Alchemy::Page", foreign_key: "page_id"
end
