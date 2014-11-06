require "config/initializers/services"
require "app/models/sector_content"
require "app/models/curated_sector"
require "app/models/latest_changes"

class SectorPresenter
  def initialize(slug)
    @slug = slug
  end

  def empty?
    no_sector_content? && no_latest_changes?
  end

  def to_hash
    if empty?
      {}
    else
      {
        title: sector_content.title,
        parent: sector_content.parent,
        details: {
          groups: groups,
          documents: documents
        }
      }
    end
  end

  def to_json
    to_hash.to_json
  end

private

  def sector_content
    @sector_content ||= SectorContent.find(@slug)
  end

  def curated_sector
    @curated_sector ||= CuratedSector.find(@slug)
  end

  def latest_changes_content
    @latest_changes_content ||= LatestChanges.find(@slug)
  end

  def no_latest_changes?
    latest_changes_content.nil? || latest_changes_content.results.empty?
  end

  def no_sector_content?
    sector_content.nil?
  end

  def documents
    latest_changes_content.results.map do |result|
      {
        latest_change_note: result[:latest_change_note],
        link: full_url(result[:link]),
        public_updated_at: result[:public_timestamp],
        title: result[:title],
      }
    end
  end

  def full_url(link)
    Plek.new.website_root+link
  end

  def groups
    if curated_sector
      filtered_groups
    else
      a_to_z_group
    end
  end

  def ordered_contents
    sector_content.results.sort_by {|r| r[:title] }
  end

  def a_to_z_group
    [
      {
        name: "A to Z",
        contents: ordered_contents.map { |content|
          {
            title: content[:title],
            web_url: content[:web_url]
          }
        }
      }
    ]
  end

  def filtered_groups
    inflated_groups.reject do |group|
      group[:contents].empty?
    end
  end

  def inflated_groups
    curated_sector.groups.map do |group|
      {
        name: group[:name],
        contents: inflated_content(group[:contents])
      }
    end
  end

  def find_content(api_url)
    sector_content.results.find do |content|
      content[:id] == api_url
    end
  end

  def inflated_content(api_urls)
    inflated = []

    api_urls.each do |api_url|
      if (content = find_content(api_url))
        inflated << {
          title: content[:title],
          web_url: content[:web_url]
        }
      end
    end

    inflated
  end
end
