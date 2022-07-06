require "spec_helper"

RSpec.describe Alchemy::Content do
  let(:element_public) { true }
  let(:element) do
    page_version = create(:alchemy_page_version, :published)
    create(:alchemy_element, :with_contents, name: "content_test", public: element_public, page_version: page_version)
  end
  let(:content) { element.content_by_name(content_name) }
  let(:content_name) { :without_searchable }

  context "searchable?" do
    context "content and element are searchable" do
      it "should be searchable" do
        expect(content.searchable?).to be(true)
      end
    end

    context "content not marked as searchable" do
      let(:content_name) { :with_searchable_disabled }
      it "should not be searchable" do
        expect(content.searchable?).to be(false)
      end
    end

    context "related element not searchable" do
      let(:element_public) { false }
      it "should not be searchable" do
        expect(content.searchable?).to be(false)
      end
    end
  end

  context "Without searchable" do
    let(:content_name) { :without_searchable }

    it "should be marked as searchable" do
      expect(content.searchable).to be(true)
    end
  end

  context "With searchable enabled" do
    let(:content_name) { :with_searchable_enabled }

    it "should be marked as searchable" do
      expect(content.searchable).to be(true)
    end
  end

  context "With searchable disabled" do
    let(:content_name) { :with_searchable_disabled }

    it "should be not marked as searchable" do
      expect(content.searchable).to be(false)
    end
  end

  describe "#searchable_ingredient" do
    subject { content.searchable_ingredient }

    before do
      expect(content).to receive(:essence_type) { essence_type }
      expect(content).to receive(:essence) { essence }
    end

    context "for a EssenceText" do
      let(:essence_type) { "Alchemy::EssenceText" }
      let(:essence) { double(body: "The title") }

      it "returns the body" do
        expect(subject).to eq("The title")
      end
    end

    context "for a EssenceRichtext" do
      let(:essence_type) { "Alchemy::EssenceRichtext" }
      let(:essence) { double(stripped_body: "The text") }

      it "returns the stripped body" do
        expect(subject).to eq("The text")
      end
    end

    context "for a EssencePicture" do
      let(:essence_type) { "Alchemy::EssencePicture" }
      let(:essence) { double(caption: "The caption") }

      it "returns the caption" do
        expect(subject).to eq("The caption")
      end
    end
  end
end
