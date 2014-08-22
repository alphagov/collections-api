require "spec_helper"
require "support/helpers/content_api_helpers"
require 'config/initializers/services'
require 'app/models/sector_content'

RSpec.describe SectorContent do
  include ContentApiHelpers

  before do
    stub_content_api
  end

  it "holds information about the sector" do
    sector_content = SectorContent.new("oil-and-gas/licensing")

    expect(sector_content.title).to eq("Licensing")
  end

  it "retrieves non curated sector content from the content api" do
    expected_title_from_content_api_stub = "Oil and gas: carbon storage public register"
    sector_content = SectorContent.new("oil-and-gas/licensing")

    expect(sector_content.results[1]["title"]).to eq expected_title_from_content_api_stub
  end
end
