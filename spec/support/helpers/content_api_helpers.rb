require "config/initializers/services"

module ContentApiHelpers
  def mock_content_api
    content_api = double(:content_api, tag: nil, with_tag: nil)
    real_content_api = CollectionsAPI.services(:content_api)
    CollectionsAPI.services(:content_api, content_api)

    yield

    CollectionsAPI.services(:content_api, real_content_api)
  end

  def stub_content_api_with_content
    allow(CollectionsAPI.services(:content_api)).to receive(:tag).with("oil-and-gas/offshore", "specialist_sector").and_return({
      "id" => "https://contentapi.example.com/tags/specialist_sector/oil-and-gas%2Foffshore.json",
      "slug" => "oil-and-gas/offshore",
      "web_url" => "https://www.example.com/oil-and-gas/offshore",
      "title" => "Offshore",
      "details" => {
        "description" => nil,
        "short_description" => nil,
        "type" => "specialist_sector"
      },
      "content_with_tag" => {
        "id" => "https://contentapi.example.com/with_tag.json?specialist_sector=oil-and-gas%2Foffshore",
        "web_url" => "https://www.example.com/oil-and-gas/offshore"
      },
      "state" => "live",
      "parent" => {
        "id" => "https://contentapi.example.com/tags/specialist_sector/oil-and-gas.json",
        "slug" => "oil-and-gas",
        "web_url" => "https://www.example.com/oil-and-gas",
        "title" => "Oil and gas",
        "details" => {
          "description" => nil,
          "short_description" => nil,
          "type" => "specialist_sector"
        },
        "content_with_tag" => {
          "id" => "https://contentapi.example.com/with_tag.json?specialist_sector=oil-and-gas",
          "web_url" => "https://www.example.com/oil-and-gas"
        },
        "state" => "live",
        "parent" => nil
      },
      "_response_info" => {
        "status" => "ok"
      }
    })

    allow(CollectionsAPI.services(:content_api)).to receive(:with_tag).with("oil-and-gas/offshore", "specialist_sector").and_return({
      "description" => "All content with the 'oil-and-gas/offshore' specialist_sector",
      "total" => 12,
      "start_index" => 1,
      "page_size" => 12,
      "current_page" => 1,
      "pages" => 1,
      "results" => [
        {
          "id" => "http://example.com/api/oil-rig-safety-requirements.json",
          "web_url" => "https://www.example.com/oil-rig-safety-requirements",
          "title" => "Oil rig safety requirements",
          "format" => "detailed_guide",
          "owning_app" => "whitehall",
          "in_beta" => false,
          "updated_at" => "2014-04-21T16:15:22+01:00",
          "details" => {
            "description" => "Important offshore rig safety information"
          }
        },
        {
          "id" => "http://example.com/api/oil-rig-staffing.json",
          "web_url" => "https://www.example.com/oil-rig-staffing",
          "title" => "Oil rig staffing",
          "format" => "detailed_guide",
          "owning_app" => "whitehall",
          "in_beta" => false,
          "updated_at" => "2014-04-21T16:15:22+01:00",
          "details" => {
            "description" => "Rules and regulations for staffing oil and gas rigs"
          }
        },
        {
          "id" => "http://example.com/api/undersea-piping-restrictions.json",
          "web_url" => "https://www.example.com/undersea-piping-restrictions",
          "title" => "Undersea piping restrictions",
          "format" => "detailed_guide",
          "owning_app" => "whitehall",
          "in_beta" => false,
          "updated_at" => "2014-04-21T16:15:22+01:00",
          "details" => {
            "description" => "Restrictions on running undersea piping"
          }
        },
        {
          "id" => "http://example.com/api/north-sea-shipping-lanes.json",
          "web_url" => "https://www.example.com/north-sea-shipping-lanes",
          "title" => "North Sea shipping lanes",
          "format" => "detailed_guide",
          "owning_app" => "whitehall",
          "in_beta" => false,
          "updated_at" => "2014-04-21T16:15:22+01:00",
          "details" => {
            "description" => "Details of shipping lanes throughout the North Sea"
          }
        }
      ]
    })
  end
end

RSpec.configure do |config|
  config.include(ContentApiHelpers, type: :model)
  config.around(:each, type: :model) do |example|
    RSpec::Mocks.with_temporary_scope do
      mock_content_api(&example)
    end
  end
end
