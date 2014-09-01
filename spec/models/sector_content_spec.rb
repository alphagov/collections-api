require "spec_helper"
require "support/helpers/content_api_helpers"
require "app/models/sector_content"

RSpec.describe SectorContent, type: :model do
  context "when the sector is missing" do
    it "returns a nil object" do
      sector_content = SectorContent.find("oil-and-gas/offshore")

      expect(sector_content).to be_nil
    end
  end

  context "when the sector is present" do
    before do
      stub_content_api_with_content
    end

    it "retrieves information about the sector" do
      sector_content = SectorContent.find("oil-and-gas/offshore")

      expect(sector_content.title).to eq("Offshore")
      expect(sector_content.parent[:title]).to eq("Oil and gas")
    end

    it "retrieves non curated sector content from the content api" do
      expected_title_from_content_api_stub = "Oil rig safety requirements"
      sector_content = SectorContent.find("oil-and-gas/offshore")

      expect(sector_content.results.first["title"]).to eq(expected_title_from_content_api_stub)
    end
  end
end
