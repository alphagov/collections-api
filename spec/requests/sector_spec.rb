require "rails_helper"
require 'gds_api/test_helpers/content_api'
require 'gds_api/test_helpers/content_store'
require 'gds_api/test_helpers/rummager'

RSpec.describe "Requests for specialist sectors", type: :request do
  include GdsApi::TestHelpers::ContentApi
  include GdsApi::TestHelpers::ContentStore
  include GdsApi::TestHelpers::Rummager

  let(:website_root){ Plek.new.website_root }

  context "with a missing sector" do
    before do
      stub_rummager_without_content
      content_api_does_not_have_tag("specialist_sector", "oil-and-gas/offshore")
    end

    it "returns a 404" do
      get_specialist_sector "oil-and-gas/offshore"
      expect(response.body).to eq("{}")
      expect(response.status).to eq(404)
    end
  end

  context "with an uncurated sector" do
    before do
      content_api_has_tag("specialist_sector", "oil-and-gas")
      content_api_has_tag("specialist_sector", "oil-and-gas/offshore", "oil-and-gas")
      content_api_has_artefacts_with_a_tag("specialist_sector", "oil-and-gas/offshore", ["zzzz-content", "some-content"])
      content_store_does_not_have_item("/oil-and-gas/offshore")
      stub_rummager_with_content
    end

    it "returns all sector content items in A to Z" do
      get_specialist_sector "oil-and-gas/offshore"

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["title"]).to eq("Offshore")
      expect(JSON.parse(response.body)["details"]).to include(
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
      stub_rummager_with_content
    end

    it "returns all sector content grouped" do
      get_specialist_sector "oil-and-gas/offshore"

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["details"]).to include(
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

  context "with changed documents" do
    before do
      content_api_has_tag("specialist_sector", "oil-and-gas")
      content_api_has_tag("specialist_sector", "oil-and-gas/offshore", "oil-and-gas")
      content_api_has_artefacts_with_a_tag("specialist_sector", "oil-and-gas/offshore", ["zzzz-content", "some-content"])
      stub_rummager_with_content
      content_store_has_item("/oil-and-gas/offshore", {
        title: "Offshore",
        description: "Offshore drilling and exploration",
        public_updated_at: 10.days.ago.iso8601,
        details: {
          groups: []
        }
      })
    end

    it "returns latest change notes" do
      get_specialist_sector "oil-and-gas/offshore"

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["details"]["documents"]).to include(
        { "latest_change_note" => "This has changed",
          "link" => "#{website_root}/government/collections/north-sea-shipping-lanes",
          "public_updated_at" => "2014-10-16T10:31:28+01:00",
          "title" => "North Sea shipping lanes" })
    end

    it 'accepts the "start" and "count" parameters' do
      stub_rummager_with_paginated_content(start: 50, count: 25, total: 100)

      get_specialist_sector 'oil-and-gas/offshore?start=50&count=25'

      body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(body['details']['documents_start']).to eq(50)
      expect(body['details']['documents_total']).to eq(100)
    end
  end

  def get_specialist_sector(slug)
    get "/specialist-sectors/#{slug}", { "ACCEPT" => "application/json" }
  end
end
