require "rails_helper"

RSpec.describe "Latest change notes for subtopic", type: :request do
  it "gets the latest change notes for a subtopic" do

    rummager_results = {
      results: [
        {
          latest_change_note: "changed",
          public_timestamp: "2014-10-16T10:31:28+01:00",
          title: "Revenue and Customs Briefs",
          link: "/government/collections/revenue-and-customs-briefs",
          index: "government",
          _id: "/government/collections/revenue-and-customs-briefs",
          document_type: "edition"
        },
        {
          latest_change_note: "changed too",
          public_timestamp: "2014-11-16T10:31:28+01:00",
          title: "Revenue and Customs Briefs",
          link: "/government/collections/revenue-and-customs-briefs",
          index: "government",
          _id: "/government/collections/revenue-and-customs-briefs",
          document_type: "edition"
        },
      ]
    }

    subtopic = "oil-and-gas/fields-and-wells"
    rummager_double = double("rummager")
    allow(CollectionsAPI).to receive(:services).with(:rummager).and_return(rummager_double)
    allow(rummager_double).to receive(:unified_search).and_return(rummager_results)

    get "specialist-sectors/#{subtopic}/latest-changes"

    expect(response.status).to eq 200
  end
end
