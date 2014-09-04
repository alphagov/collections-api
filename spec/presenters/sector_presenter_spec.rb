require "spec_helper"

require "support/helpers/content_api_helpers"
require "support/helpers/content_store_helpers"

require "active_support/core_ext/hash/keys"

require "app/presenters/sector_presenter"

RSpec.describe SectorPresenter, type: :model do
  describe "#to_json" do
    it "produces the JSON version of #to_hash" do
      stub_content_api_with_content

      presenter = SectorPresenter.new("oil-and-gas/offshore")

      expect(presenter.to_json).to eq(presenter.to_hash.to_json)
    end
  end

  context "when the sector is missing" do
    it "is empty" do
      presenter = SectorPresenter.new("absent-sector")

      expect(presenter).to be_empty
      expect(presenter.to_hash).to eq({})
    end
  end

  context "when only the sector is present" do
    before do
      stub_content_api_with_content
    end

    it "returns an A to Z group containing the sorted contents" do
      presenter = SectorPresenter.new("oil-and-gas/offshore")

      expect(presenter).not_to be_empty
      expect(presenter.to_hash).to include(
        title: "Offshore",
        details: {
          groups: [
            {
              name: "A to Z",
              contents: [
                {
                  title: "North Sea shipping lanes",
                  web_url: "https://www.example.com/north-sea-shipping-lanes"
                },
                {
                  title: "Oil rig safety requirements",
                  web_url: "https://www.example.com/oil-rig-safety-requirements"
                },
                {
                  title: "Oil rig staffing",
                  web_url: "https://www.example.com/oil-rig-staffing"
                },
                {
                  title: "Undersea piping restrictions",
                  web_url: "https://www.example.com/undersea-piping-restrictions"
                }
              ]
            }
          ]
        }
      )
    end

    it "passes along the parent" do
      presenter = SectorPresenter.new("oil-and-gas/offshore")

      expect(presenter.to_hash).to have_key(:parent)
      expect(presenter.to_hash[:parent]).to include(
        "slug" => "oil-and-gas",
        "title" => "Oil and gas"
      )
    end
  end

  context "when the sector is present and curated" do
    before do
      stub_content_api_with_content
      stub_content_store_with_content
    end

    it "returns grouped content inflated with title and web URL" do
      presenter = SectorPresenter.new("oil-and-gas/offshore")

      expect(presenter).not_to be_empty
      expect(presenter.to_hash).to include({
        title: "Offshore",
        details: {
          groups: [
            {
              name: "Oil rigs",
              contents: [
                {
                  title: "Oil rig safety requirements",
                  web_url: "https://www.example.com/oil-rig-safety-requirements"
                },
                {
                  title: "Oil rig staffing",
                  web_url: "https://www.example.com/oil-rig-staffing"
                }
              ]
            },
            {
              name: "Piping",
              contents: [
                {
                  title: "Undersea piping restrictions",
                  web_url: "https://www.example.com/undersea-piping-restrictions"
                }
              ]
            },
            {
              name: "Other",
              contents: [
                {
                  title: "North Sea shipping lanes",
                  web_url: "https://www.example.com/north-sea-shipping-lanes"
                }
              ]
            }
          ]
        }
      })
    end

    it "passes along the parent" do
      presenter = SectorPresenter.new("oil-and-gas/offshore")

      expect(presenter.to_hash).to have_key(:parent)
      expect(presenter.to_hash[:parent]).to include(
        "slug" => "oil-and-gas",
        "title" => "Oil and gas"
      )
    end
  end
end
