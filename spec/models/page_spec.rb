require "spec_helper"

RSpec.describe Alchemy::Page do
  let(:page) { create(:alchemy_page, :public) }

  describe "searchable?" do
    describe "public and not restricted page" do
      let(:page) { create(:alchemy_page, :public) }

      it 'should be searchable' do
        expect(page.searchable?).to be(true)
      end
    end

    describe "not public page" do
      let(:page) { create(:alchemy_page) }

      it 'should not be searchable' do
        expect(page.searchable?).to be(false)
      end
    end

    describe "layout page" do
      let(:page) { create(:alchemy_page, :public, :layoutpage) }

      it 'should not be searchable' do
        expect(page.searchable?).to be(false)
      end
    end
  end
end
