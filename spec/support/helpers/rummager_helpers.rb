require "config/initializers/services"

module RummagerHelpers
  def stub_rummager_result
    {
      "latest_change_note" => "This has changed",
      "public_timestamp" => "2014-10-16T10:31:28+01:00",
      "title" => "North Sea shipping lanes",
      "link" => "/government/collections/north-sea-shipping-lanes",
      "index" => "government",
      "_id" => "/government/collections/north-sea-shipping-lanes",
      "document_type" => "edition"
    }
  end

  def stub_rummager_with_content
    rummager_results = {
      "results" => [
        stub_rummager_result
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

  def stub_rummager_with_paginated_content(start:, total:)
    rummager_response = {
      'results' => [
        stub_rummager_result
      ],
      'start' => start,
      'total' => total,
    }

    rummager_double = double('rummager')
    expect(rummager_double).to receive(:unified_search).with(
      hash_including(start: start.to_s)
    ).and_return(rummager_response)

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
