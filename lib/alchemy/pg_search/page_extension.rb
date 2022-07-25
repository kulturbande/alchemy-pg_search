# Enable Postgresql full text indexing.
#
Alchemy::Page.class_eval do
  include PgSearch::Model

  after_save :rebuild_related_essences
  # after_save :update_related_search_documents

  multisearchable(
    against: [
      :meta_description,
      :meta_keywords,
      :name,
    ],
    additional_attributes: -> (page) { { page_id: page.id } },
    if: :searchable?
  )

  def rebuild_related_essences
    contents.all.each do |content|
      content.essence.update_pg_search_document if Alchemy::PgSearch.is_searchable_essence? content.essence_type.sub("Alchemy::", "")
    end
    true
  end

  def update_related_search_documents
    PgSearch::Document.where(page_id: id).where.not(searchable_type: "Alchemy::Page").find_each do |document|
      document.searchable.update_pg_search_document
    end
  end

  def searchable?
    public? && !restricted? && !layoutpage?
  end
end
