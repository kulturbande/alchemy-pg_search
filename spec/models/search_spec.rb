require 'spec_helper'

describe Alchemy::PgSearch::Search do
  let(:page_version) { create(:alchemy_page_version, :published) }
  let(:element) { create(:alchemy_element, :with_contents, name: "essence_test", public: true, page_version: page_version) }
  let(:prepared_essences) do
    {:essence_text => :body, :essence_richtext => :body, :essence_picture => :caption}.each do |essence_name, field|
      essence = element.content_by_name(essence_name).essence
      essence[field] = "foo"
      essence.save
    end
  end

  context 'rebuild' do
    it 'should have zero indexed documents' do
      expect(PgSearch::Document.count).to be(0)
    end

    context 'after rebuild' do
      before do
        prepared_essences
        Alchemy::PgSearch::Search.rebuild
      end

      it 'should have entries (2 Pages + 3 Essences)' do
        expect(PgSearch::Document.count).to eq(5)
      end

      it 'should have one essence_text entry' do
        expect(PgSearch::Document.where(searchable_type: "Alchemy::EssenceText").count).to eq(1)
      end

      it 'should have one essence_richtext entry' do
        expect(PgSearch::Document.where(searchable_type: "Alchemy::EssenceRichtext").count).to eq(1)
      end

      it 'should have one essence_picture entry' do
        expect(PgSearch::Document.where(searchable_type: "Alchemy::EssencePicture").count).to eq(1)
      end
    end
  end

  context 'index_page' do
    before do
      prepared_essences
      PgSearch::Document.destroy_all # clean the whole index
    end
    
    it 'should have zero indexed documents' do
      expect(PgSearch::Document.count).to be(0)
    end

    context 'first_page' do
      let(:page) { Alchemy::Page.first }

      before do
        Alchemy::PgSearch::Search.index_page page
      end

      it 'should have only one entry' do
        expect(PgSearch::Document.count).to be(1)
      end

      it 'should be the first page' do
        expect(PgSearch::Document.first.page_id).to be(page.id)
      end
    end

    context 'second_page' do
      let(:page) { Alchemy::Page.last }

      before do
        Alchemy::PgSearch::Search.index_page page
      end

      it 'should have four entries (1 Page + 3 Essences)' do
        expect(PgSearch::Document.count).to be(4)
      end

      it 'should be all relate to the same page ' do
        PgSearch::Document.all.each do |document|
          expect(document.page_id).to be(page.id)
        end
      end
    end
  end
end
