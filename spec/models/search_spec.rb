require 'spec_helper'

describe Alchemy::PgSearch::Search do
  let(:page_version) { create(:alchemy_page_version, :published) }
  let(:element) { create(:alchemy_element, :with_contents, name: "essence_test", public: true, page_version: page_version) }

  context 'rebuild' do
    it 'should have zero indexed documents' do
      expect(PgSearch::Document.count).to be(0)
    end

    context 'after rebuild' do
      before do
        {:essence_text => :body, :essence_richtext => :body, :essence_picture => :caption}.each do |essence_name, field|
          essence = element.content_by_name(essence_name).essence
          essence[field] = "foo"
          essence.save
        end
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
end
