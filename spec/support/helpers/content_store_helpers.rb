require "config/initializers/services"

module ContentStoreHelpers
  def mock_content_store
    content_store = double(:content_store, content_item: nil)
    real_content_store = CollectionsAPI.services(:content_store)
    CollectionsAPI.services(:content_store, content_store)

    yield

    CollectionsAPI.services(:content_store, real_content_store)
  end

  def stub_content_store_with_content
    stub_content_store_with("/oil-and-gas/offshore", {
      title: "Offshore",
      description: "Important information about offshore drilling",
      details: {
        beta: true,
        groups: [
          {
            "name" => "Oil rigs",
            "contents" => [
              "http://example.com/api/oil-rig-safety-requirements.json",
              "http://example.com/api/oil-rig-staffing.json"
            ]
          },
          {
            "name" => "Piping",
            "contents" => [
              "http://example.com/api/undersea-piping-restrictions.json",
              "http://example.com/api/an-untagged-document-about-oil.json"
            ]
          },
          {
            "name" => "A group with only untagged content",
            "contents" => [
              "http://example.com/api/an-untagged-document-about-oil.json"
            ]
          },
          {
            "name" => "Other",
            "contents" => [
              "http://example.com/api/north-sea-shipping-lanes.json"
            ]
          }
        ]
      }
    })
  end

  def stub_content_store_with_content_but_empty_groups
    stub_content_store_with("/oil-and-gas/offshore", {
      title: "Offshore",
      description: "Important information about offshore drilling",
      details: {
        groups: [],
      }
    })
  end

  def stub_content_store_with_content_but_no_groups
    stub_content_store_with("/oil-and-gas/offshore", {
      title: "Offshore",
      description: "Important information about offshore drilling",
      details: {
        groups: [
          {
            "name" => "Other",
            "contents" => [
              "http://example.com/api/oil-rig-safety-requirements.json",
              "http://example.com/api/oil-rig-staffing.json",
              "http://example.com/api/undersea-piping-restrictions.json",
              "http://example.com/api/an-untagged-document-about-oil.json",
              "http://example.com/api/north-sea-shipping-lanes.json"
            ]
          }
        ]
      }
    })
  end

  def stub_content_store_with(base_path, options = {})
    allow(CollectionsAPI.services(:content_store)).to receive(:content_item).with(base_path).and_return({
      "base_path" => base_path,
      "title" => options[:title],
      "description" => options[:description],
      "format" => "specialist_sector",
      "need_ids" => [],
      "public_updated_at"=> "2014-03-04T13:58:11+00:00",
      "updated_at" => "2014-03-04T14:15:17+00:00",
      "details" => options[:details]
    })
  end
end

RSpec.configure do |config|
  config.include(ContentStoreHelpers, type: :model)
  config.around(:example, type: :model) do |example|
    RSpec::Mocks.with_temporary_scope do
      mock_content_store(&example)
    end
  end
end
