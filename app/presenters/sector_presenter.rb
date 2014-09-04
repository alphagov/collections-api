require "config/initializers/services"
require "app/models/sector_content"
require "app/models/curated_sector"

class SectorPresenter
  def initialize(slug)
    @slug = slug
  end

  def empty?
    sector_content.nil?
  end

  def to_hash
    if empty?
      {}
    else
      {
        title: sector_content.title,
        parent: sector_content.parent,
        details: {
          groups: groups
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

  def groups
    if curated_sector
      inflated_groups
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

  def inflated_groups
    curated_sector.groups.map do |group|
      {
        name: group[:name],
        contents: group[:contents].map { |api_url|
          content = find_content(api_url)

          {
            title: content[:title],
            web_url: content[:web_url]
          }
        }
      }
    end
  end

  def find_content(api_url)
    sector_content.results.find do |content|
      content[:id] == api_url
    end
  end
end
