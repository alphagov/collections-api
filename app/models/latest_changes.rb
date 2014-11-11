require "active_support/core_ext/hash/indifferent_access"

class LatestChanges
  DEFAULT_RESULTS_PER_PAGE = 50
  MAX_RESULTS_PER_PAGE = 100

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
     count: valid_count_value(options).to_s,
     start: valid_start_value(options).to_s,
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

private
  def self.valid_start_value(options)
    if options[:start] && options[:start].to_i > 0
      options[:start].to_i
    else
      0
    end
  end

  def self.valid_count_value(options)
    count = options[:count]
    count = count.nil? ? 0 : count.to_i
    if count <= 0
      count = DEFAULT_RESULTS_PER_PAGE
    elsif count > MAX_RESULTS_PER_PAGE
      count = MAX_RESULTS_PER_PAGE
    end
    count
  end
end
