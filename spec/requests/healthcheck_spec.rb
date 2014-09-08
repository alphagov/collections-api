require "rails_helper"
require 'gds_api/test_helpers/content_api'
require 'gds_api/test_helpers/content_store'

RSpec.describe "Healthcheck requests", type: :request do
  include GdsApi::TestHelpers::ContentApi
  include GdsApi::TestHelpers::ContentStore

  before :each do
    content_api_has_root_tags("section", ["some", "slugs"])
    content_store_does_not_have_item('/does/not/exist')
  end

  context "when content-api and content-store are both available" do
    it 'reports an "OK" status' do
      get "/healthcheck"

      expect(response.status).to eq(200)
      expect(json_response["status"]).to eq("ok")
    end
  end

  context "when content-api returns an error response" do
    before do
      content_api_isnt_available
    end

    it 'reports a critical error' do
      get "/healthcheck"
      expect(response.status).to eq(200)
      expect(json_response["status"]).to eq("critical")
    end
  end

  context "when content-store returns an error response" do
    before do
      content_store_isnt_available
    end

    it 'reports a critical error' do
      get "/healthcheck"
      expect(response.status).to eq(200)
      expect(json_response["status"]).to eq("critical")
    end
  end


private

  def json_response
    JSON.parse(response.body)
  end

  def content_api_isnt_available
    stub_request(:any, /#{Plek.new.find('contentapi')}*/).
        to_return(status: 503)
  end
end
