require "spec_helper"
require "config/initializers/services"
require "app/models/latest_changes_content"

RSpec.describe LatestChangesContent, type: :model do
  describe "#find" do
    context "with an empty rummager result set" do
      it "returns an empty results array" do
        rummager = double("rummager", unified_search: { "results" => [] })
        CollectionsAPI.services(:rummager, rummager)
        latest_content = LatestChangesContent.find("topic_search")

        expect(latest_content.results).to eq []
      end
    end

    context "with a nil rummager result set" do
      it "returns a nil object" do
        rummager = double("rummager", unified_search: nil)
        CollectionsAPI.services(:rummager, rummager)

        expect(LatestChangesContent.find("topic_search")).to eq nil
      end
    end

    context "with a rummager result set" do
      it "returns a populated results array" do
        rummager_results = {
          "results" => [
            {
              "title" => "Revenue and Customs Briefs",
            }
          ]
        }
        rummager = double("rummager", unified_search: rummager_results)
        CollectionsAPI.services(:rummager, rummager)
        latest_content = LatestChangesContent.find("topic_search")

        expect(latest_content.results[0]["title"]).to eq "Revenue and Customs Briefs"
      end
    end

    it "it queries rummager for the latest changed content" do
      rummager = double("rummager")
      slug = "sluggy"
      query = {
        count: "50",
        filter_specialist_sectors: [slug],
        order: "-public_timestamp",
        fields: %w(title link latest_change_note public_timestamp)
      }
      CollectionsAPI.services(:rummager, rummager)

      expect(rummager).to receive(:unified_search).with(query)

      LatestChangesContent.find(slug)
    end
  end
end
