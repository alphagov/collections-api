require "spec_helper"
require "support/helpers/content_api_helpers"
require "support/helpers/content_store_helpers"
require "support/helpers/rummager_helpers"
require "active_support/core_ext/hash/keys"
require "app/presenters/sector_presenter"

RSpec.describe SectorPresenter, type: :model do
  let(:website_root){ Plek.new.website_root }

  describe "#to_json" do
    it "produces the JSON version of #to_hash" do
      stub_content_api_with_content
      stub_rummager_with_content

      presenter = SectorPresenter.new("oil-and-gas/offshore")

      expect(presenter.to_json).to eq(presenter.to_hash.to_json)
    end
  end

  context "when the sector is missing" do
    it "is empty" do
      stub_rummager_without_content

      presenter = SectorPresenter.new("absent-sector")

      expect(presenter).to be_empty
      expect(presenter.to_hash).to eq({})
    end
  end

  context "when only the sector is present" do
    before do
      stub_content_api_with_content
      stub_rummager_with_content
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
          ],
          documents: [
            {
              latest_change_note: "This has changed",
              link: "#{website_root}/government/collections/north-sea-shipping-lanes",
              public_updated_at: "2014-10-16T10:31:28+01:00",
              title: "North Sea shipping lanes",
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

  context "with changed documnets" do
    before do
      stub_content_api_with_content
      stub_content_store_with_content
      stub_rummager_with_content
    end

    it "returns the changed content" do
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
          ],
          documents: [
            {
              latest_change_note: "This has changed",
              link: "#{website_root}/government/collections/north-sea-shipping-lanes",
              public_updated_at: "2014-10-16T10:31:28+01:00",
              title: "North Sea shipping lanes",
            }
          ]
        }
      })
    end
  end

  context "when the sector is present and curated" do
    before do
      stub_content_api_with_content
      stub_content_store_with_content
      stub_rummager_with_content
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
          ],
          documents: [
            {
              latest_change_note: "This has changed",
              link: "#{website_root}/government/collections/north-sea-shipping-lanes",
              public_updated_at: "2014-10-16T10:31:28+01:00",
              title: "North Sea shipping lanes",
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

    it "removes content which has been untagged" do
      presenter = SectorPresenter.new("oil-and-gas/offshore")

      piping_group = find_group(presenter, "Piping")

      expect(piping_group[:contents]).to eq([{
        title: "Undersea piping restrictions",
        web_url: "https://www.example.com/undersea-piping-restrictions"
      }])
    end

    it "removes groups where all the content has been untagged" do
      presenter = SectorPresenter.new("oil-and-gas/offshore")

      untagged_group = find_group(presenter, "A group with only untagged content")

      expect(untagged_group).to be_nil
    end
  end

  def find_group(presenter, name)
    presenter.to_hash[:details][:groups].find { |g| g[:name] == name }
  end
end

RSpec.describe SectorPresenter, "#empty?", type: :model do
  context "sector content is nil" do
    before do
      content_api = double(:content_api, tag: nil, with_tag: nil)
      real_content_api = CollectionsAPI.services(:content_api)
      CollectionsAPI.services(:content_api, content_api)
    end

    it "returns true if rummager is nil" do
      rummager_double = double("rummager", unified_search: nil)
      rummager = CollectionsAPI.services(:rummager, rummager_double)

      presenter = SectorPresenter.new("")

      expect(presenter.empty?).to eq(true)
    end

    it "returns true if rummager returns an empty array" do
      rummager_results = { "results" => [] }
      rummager_double = double("rummager", unified_search: rummager_results)
      rummager = CollectionsAPI.services(:rummager, rummager_double)

      presenter = SectorPresenter.new("")

      expect(presenter.empty?).to eq(true)
    end
  end

  context "sector content is not nil" do
    before do
      stub_content_api_with_content
    end

    it "returns false if sector rummager is nil" do
      rummager_double = double("rummager", unified_search: nil)
      rummager = CollectionsAPI.services(:rummager, rummager_double)

      presenter = SectorPresenter.new("oil-and-gas/offshore")

      expect(presenter.empty?).to eq(false)
    end
  end
end
