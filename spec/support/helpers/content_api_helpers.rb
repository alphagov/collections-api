module ContentApiHelpers
  def stub_content_api
    content_api = double(:content_api)

    allow(content_api).to receive(:tag).with("oil-and-gas/licensing", "specialist_sector").
      and_return({
        "id" => "https://contentapi.preview.alphagov.co.uk/tags/specialist_sector/oil-and-gas%2Flicensing.json",
        "slug" => "oil-and-gas/licensing",
        "web_url" => "https://www.preview.alphagov.co.uk/oil-and-gas/licensing",
        "title" => "Licensing",
        "details" => {
          "description" => nil,
          "short_description" => nil,
          "type" => "specialist_sector"
        },
        "content_with_tag" => {
          "id" => "https://contentapi.preview.alphagov.co.uk/with_tag.json?specialist_sector=oil-and-gas%2Flicensing",
          "web_url" => "https://www.preview.alphagov.co.uk/oil-and-gas/licensing"
        },
        "state" => "live",
        "parent" => {
          "id" => "https://contentapi.preview.alphagov.co.uk/tags/specialist_sector/oil-and-gas.json",
          "slug" => "oil-and-gas",
          "web_url" => "https://www.preview.alphagov.co.uk/oil-and-gas",
          "title" => "Oil and gas",
          "details" => {
            "description" => nil,
            "short_description" => nil,
            "type" => "specialist_sector"
          },
          "content_with_tag" => {
            "id" => "https://contentapi.preview.alphagov.co.uk/with_tag.json?specialist_sector=oil-and-gas",
            "web_url" => "https://www.preview.alphagov.co.uk/oil-and-gas"
          },
          "state" => "live",
          "parent" => nil
        },
        "_response_info" => {
          "status" => "ok"
        }
      })

    allow(content_api).to receive(:with_tag).with("oil-and-gas/licensing", "specialist_sector").
      and_return({
      "description" => "All content with the 'oil-and-gas/licensing' specialist_sector",
      "total" => 12,
      "start_index" => 1,
      "page_size" => 12,
      "current_page" => 1,
      "pages" => 1,
      "results" => [{
        "id" => "https://contentapi.preview.alphagov.co.uk/offshore-energy-strategic-environmental-assessment-sea-an-overview-of-the-sea-process.json",
        "web_url" => "https://www.preview.alphagov.co.uk/offshore-energy-strategic-environmental-assessment-sea-an-overview-of-the-sea-process",
        "title" => "Offshore Energy Strategic Environmental Assessment (SEA): An overview of the SEA process",
        "format" => "detailed_guide",
        "owning_app" => "whitehall",
        "in_beta" => false,
        "updated_at" => "2014-04-21T16:15:22+01:00",
        "details" => {
          "description" => "An explanation of the offshore SEA  process, including documentation of the most recent assessment and related consultation"
        }
      }, {
        "id" => "https://contentapi.preview.alphagov.co.uk/oil-and-gas-carbon-storage-public-register.json",
        "web_url" => "https://www.preview.alphagov.co.uk/oil-and-gas-carbon-storage-public-register",
        "title" => "Oil and gas: carbon storage public register",
        "format" => "detailed_guide",
        "owning_app" => "whitehall",
        "in_beta" => false,
        "updated_at" => "2014-04-21T15:27:08+01:00",
        "details" => {
          "description" => "The Carbon Storage Public Register"
        }
      }]
    })

    CollectionsAPI.services(:content_api, content_api)
  end
end
