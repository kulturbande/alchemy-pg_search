# Enable Postgresql full text indexing.
#
module Alchemy::PgSearch::PageExtension
  def self.prepended(base)
    base.include PgSearch::Model
    base.after_save :remove_unpublished_pages # TODO: test after save
    base.multisearchable(
      against: [
        :meta_description,
        :meta_keywords,
        :name,
      ],
      additional_attributes: -> (page) { { page_id: page.id } },
      if: :searchable?
    )
  end

  def remove_unpublished_pages
    Alchemy::PgSearch::Search.remove_page self unless searchable?
  end

  def searchable?
    public? && !layoutpage?
  end
end

Alchemy::Page.prepend(Alchemy::PgSearch::PageExtension)
