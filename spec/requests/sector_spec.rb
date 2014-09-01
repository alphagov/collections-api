require "rails_helper"
require 'gds_api/test_helpers/content_api'
require 'gds_api/test_helpers/content_store'

RSpec.describe "Requests for specialist sectors", type: :request do
  include GdsApi::TestHelpers::ContentApi
  include GdsApi::TestHelpers::ContentStore

  context "with a missing sector" do
    before do
      content_api_does_not_have_tag("specialist_sector", "oil-and-gas/offshore")
    end

    it "returns a 404" do
      get_specialist_sector "oil-and-gas/offshore"
      expect(response.status).to eq(404)
    end
  end

  context "with an uncurated sector" do
    before do
      content_api_has_tag("specialist_sector", "oil-and-gas")
      content_api_has_tag("specialist_sector", "oil-and-gas/offshore", "oil-and-gas")
      content_api_has_artefacts_with_a_tag("specialist_sector", "oil-and-gas/offshore", ["zzzz-content", "some-content"])

      content_store_does_not_have_item("/oil-and-gas/offshore")
    end

    it "returns all sector content items in A to Z" do
      get_specialist_sector "oil-and-gas/offshore"

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["title"]).to eq("Offshore")
      expect(JSON.parse(response.body)).to include(
        "groups" => [
          "name" => "A to Z",
          "contents" => [
            {
              "title" => "Some content",
              "web_url" => "http://frontend.test.gov.uk/some-content"
            },
            {
              "title" => "Zzzz content",
              "web_url" => "http://frontend.test.gov.uk/zzzz-content"
            }
          ]
        ]
      )
      expect(JSON.parse(response.body)["parent"]).to include(
        "title" => "Oil and gas"
      )
    end
  end

  context "with a curated sector" do
    before do
      content_api_has_tag("specialist_sector", "oil-and-gas")
      content_api_has_tag("specialist_sector", "oil-and-gas/offshore", "oil-and-gas")
      content_api_has_artefacts_with_a_tag("specialist_sector", "oil-and-gas/offshore", ["zzzz-content", "some-content"])

      content_store_has_item("/oil-and-gas/offshore", {
        title: "Offshore",
        description: "Offshore drilling and exploration",
        public_updated_at: 10.days.ago.iso8601,
        details: {
          groups: [
            {
              name: "A test group",
              contents: [
                "#{Plek.current.find("contentapi")}/zzzz-content.json",
                "#{Plek.current.find("contentapi")}/some-content.json"
              ]
            }
          ]
        }
      })
    end

    it "returns all sector content grouped" do
      get_specialist_sector "oil-and-gas/offshore"

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to include(
        "groups" => [
          "name" => "A test group",
          "contents" => [
            {
              "title" => "Zzzz content",
              "web_url" => "http://frontend.test.gov.uk/zzzz-content"
            },
            {
              "title" => "Some content",
              "web_url" => "http://frontend.test.gov.uk/some-content"
            }
          ]
        ]
      )
    end
  end

  def get_specialist_sector(slug)
    get "/specialist-sectors/#{slug}", {"ACCEPT" => "application/json"}
  end
end
