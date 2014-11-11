require "spec_helper"
require "config/initializers/services"
require "app/models/latest_changes"

RSpec.describe LatestChanges, type: :model do
  describe ".find" do
    let(:slug) { 'sluggy' }
    let(:base_rummager_query) {
      {
        count: "50",
        start: "0",
        filter_specialist_sectors: [slug],
        order: "-public_timestamp",
        fields: %w(title link latest_change_note public_timestamp)
      }
    }

    context "with an empty rummager result set" do
      it "returns an empty results array" do
        rummager = double("rummager", unified_search: { "results" => [] })
        CollectionsAPI.services(:rummager, rummager)

        latest_content = LatestChanges.find("topic_search")

        expect(latest_content.results).to eq([])
      end
    end

    context "with a nil rummager result set" do
      it "returns a nil object" do
        rummager = double("rummager", unified_search: nil)
        CollectionsAPI.services(:rummager, rummager)

        expect(LatestChanges.find("topic_search")).to eq(nil)
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

        latest_content = LatestChanges.find("topic_search")

        expect(latest_content.results[0]["title"]).to eq("Revenue and Customs Briefs")
      end

      it 'returns information for pagination' do
        rummager_results = {
          'start' => '50',
          'total' => '200',
          'results' => [],
        }

        rummager = double("rummager", unified_search: rummager_results)
        CollectionsAPI.services(:rummager, rummager)

        latest_content = LatestChanges.find("topic_search")

        expect(latest_content.start).to eq(50)
        expect(latest_content.total).to eq(200)
      end
    end

    it "it queries rummager for the latest changed content" do
      rummager = double("rummager")
      CollectionsAPI.services(:rummager, rummager)

      expect(rummager).to receive(:unified_search).with(base_rummager_query)

      LatestChanges.find(slug)
    end

    context 'start value' do
      it "passes the starting value into the rummager query" do
        rummager = double("rummager")
        CollectionsAPI.services(:rummager, rummager)

        expect(rummager).to receive(:unified_search).with(
          base_rummager_query.merge(start: '10')
        )

        LatestChanges.find(slug, start: 10)
      end

      it 'defaults to zero given a nil value' do
        rummager = double("rummager")
        CollectionsAPI.services(:rummager, rummager)

        expect(rummager).to receive(:unified_search).with(
          base_rummager_query.merge(start: '0')
        )

        LatestChanges.find(slug, start: nil)
      end

      it 'defaults to zero given a blank string' do
        rummager = double("rummager")
        CollectionsAPI.services(:rummager, rummager)

        expect(rummager).to receive(:unified_search).with(
          base_rummager_query.merge(start: '0')
        )

        LatestChanges.find(slug, start: '')
      end

      it 'defaults to zero given a negative number' do
        rummager = double("rummager")
        CollectionsAPI.services(:rummager, rummager)

        expect(rummager).to receive(:unified_search).with(
          base_rummager_query.merge(start: '0')
        )

        LatestChanges.find(slug, start: -10)
      end
    end
  end
end
