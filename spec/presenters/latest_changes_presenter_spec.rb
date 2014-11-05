require "rails_helper"

RSpec.describe LatestChangesPresenter, "#to_json" do
  it "returns an array of documents" do
    rummager_results = {
      "results" => [
        {
          "latest_change_note" => "changed",
          "public_timestamp" => "2014-10-16T10:31:28+01:00",
          "title" => "Revenue and Customs Briefs",
          "link" => "/government/collections/revenue-and-customs-briefs",
          "index" => "government",
          "_id" => "/government/collections/revenue-and-customs-briefs",
          "document_type" => "edition"
        },
        {
          "latest_change_note" => "changed too",
          "public_timestamp" => "2014-11-16T10:31:28+01:00",
          "title" => "Revenue and Customs Briefs",
          "link" => "/government/collections/revenue-and-customs-briefs",
          "index" => "government",
          "_id" => "/government/collections/revenue-and-customs-briefs",
          "document_type" => "edition"
        },
      ]
    }
    rummager_double = double("rummager")
    allow(CollectionsAPI).to receive(:services).with(:rummager).and_return(rummager_double)
    allow(rummager_double).to receive(:unified_search).and_return(rummager_results)
    slug = "oil-and-gas/fields-and-wells"
    presenter = LatestChangesPresenter.new(slug)

    expect(presenter.to_json).to eq presenter.to_hash.to_json
  end

  context "empty result set" do

    it "for an empty slug the presenter will return empty json" do
      rummager_results = { "results" => [] }
      rummager_double = double("rummager")
      allow(CollectionsAPI).to receive(:services).with(:rummager).and_return(rummager_double)
      allow(rummager_double).to receive(:unified_search).and_return(rummager_results)
      slug = ""

      presenter = LatestChangesPresenter.new(slug)


      expect(presenter.to_json).to eq("{}")
    end

  end

end
