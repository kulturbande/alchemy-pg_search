require 'spec_helper'

describe Alchemy::PgSearch::PageResult do

  let(:page) { create(:alchemy_page, :public) }
  let(:query) { "foo" }
  let(:page_result) { Alchemy::PgSearch::PageResult.new(page, query) }
  let(:pg_search_document) do
    document = PgSearch::Document.new
    document.content = "Well, that's certainly good to know. #{query} Now we know what they mean by 'advanced' tactical training."
    document
  end

  context 'add_relative_document' do
    before do
      page_result.add_relative_document pg_search_document
    end

    it 'should be possible to add a relative document' do
      expect(page_result.relative_documents.first).to be(pg_search_document)
    end

    it 'should be exact two document after adding another one' do
      page_result.add_relative_document pg_search_document
      expect(page_result.relative_documents.length).to be(2)
    end
  end

  context 'first_excerpt' do
    it 'should give back the content of the pg_document' do
      page_result.add_relative_document pg_search_document

      another_pg_document = pg_search_document
      another_pg_document.content = "bar"
      page_result.add_relative_document another_pg_document

      expect(page_result.first_excerpt).to be(pg_search_document.content)
    end

    it 'should return nil if no document is available' do
      expect(page_result.first_excerpt).to be(nil)
    end
  end
end
