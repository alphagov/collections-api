require "spec_helper"
require "support/helpers/content_store_helpers"
require "config/initializers/services"
require "app/models/curated_sector"
require "time"

RSpec.describe CuratedSector, type: :model do
  context "when the sector is missing" do
    it "returns a nil object" do
      sector = CuratedSector.find("oil-and-gas/offshore")
      expect(sector).to be_nil
    end
  end

  context "when the sector is present" do
    before do
      stub_content_store_with_content
    end

    it "holds information about the sector" do
      sector = CuratedSector.find("oil-and-gas/offshore")

      expect(sector.title).to eq("Offshore")
      expect(sector.description).to eq("Important information about offshore drilling")
      expect(sector.public_updated_at).to eq(DateTime.parse("2014-03-04T13:58:11+00:00"))
    end

    describe "#groups" do
      it "provides the ordered groups hash (with indifferent access)" do
        sector = CuratedSector.find("oil-and-gas/offshore")

        expect(sector.groups.map {|g| g[:name] }).to eq(["Oil rigs", "Piping", "Other"])
        expect(sector.groups.map {|g| g[:contents] }).to eq([
          [
            "http://example.com/api/oil-rig-safety-requirements.json",
            "http://example.com/api/oil-rig-staffing.json"
          ],
          [
            "http://example.com/api/undersea-piping-restrictions.json"
          ],
          [
            "http://example.com/api/north-sea-shipping-lanes.json"
          ]
        ])
      end
    end
  end
end
