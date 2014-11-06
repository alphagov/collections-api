require "config/initializers/services"

module RummagerHelpers
  def stub_rummager_with_content
    rummager_results = {
      "results" => [
        {
          "latest_change_note" => "This has changed",
          "public_timestamp" => "2014-10-16T10:31:28+01:00",
          "title" => "North Sea shipping lanes",
          "link" => "/government/collections/north-sea-shipping-lanes",
          "index" => "government",
          "_id" => "/government/collections/north-sea-shipping-lanes",
          "document_type" => "edition"
        },
      ]
    }
    rummager_double = double("rummager", unified_search: rummager_results)
    rummager = CollectionsAPI.services(:rummager, rummager_double)
  end

  def stub_rummager_without_content
    rummager_results = {}
    rummager_double = double("rummager", unified_search: rummager_results)
    rummager = CollectionsAPI.services(:rummager, rummager_double)
  end
end

RSpec.configure do |config|
  config.include(RummagerHelpers, type: :model)
  config.include(RummagerHelpers, type: :request)
  config.around(:example, type: :model) do |example|
    RSpec::Mocks.with_temporary_scope do
      mock_content_store(&example)
    end
  end
end
