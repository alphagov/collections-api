require "active_support/core_ext/hash/indifferent_access"

class LatestChanges
  def self.find(slug, search_query_opts={})
    search_client = CollectionsAPI.services(:rummager)
    search_query = build_search_query_for(slug, search_query_opts)

    if (contents = search_client.unified_search(search_query)) && contents["results"]
      return self.new(contents)
    else
      return nil
    end
  end

  def self.build_search_query_for(slug, options)
    {
     count: "50",
     start: options.fetch(:start, 0).to_s,
     filter_specialist_sectors: [slug],
     order: "-public_timestamp",
     fields: %w(title link latest_change_note public_timestamp)
    }
  end

  def initialize(contents)
    @contents = contents
  end

  def results
    @contents["results"].map(&:with_indifferent_access)
  end

  def start
    @contents['start'].to_i
  end

  def total
    @contents['total'].to_i
  end
end
