require "spec_helper"

RSpec.describe Alchemy::Page do
  let(:page) { create(:alchemy_page, :public) }

  describe "searchable?" do
    describe "public page" do
      let(:page) { create(:alchemy_page, :public) }

      it 'should be true if page is public and not restricted' do
        expect(page.searchable?).to be(true)
      end
    end

    describe "not public page" do
      let(:page) { create(:alchemy_page) }

      it 'should be false if page is not public and not restricted' do
        expect(page.searchable?).to be(false)
      end
    end

    describe "restricted page" do
      let(:page) { create(:alchemy_page, :public, :restricted) }

      it 'should be false if page is public and restricted' do
        expect(page.searchable?).to be(false)
      end
    end
  end
end
