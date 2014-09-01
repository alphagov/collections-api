require "active_support/core_ext/hash/indifferent_access"

class SectorContent
  def self.find(slug)
    content_api = CollectionsAPI.services(:content_api)

    if (sector = content_api.tag(slug, "specialist_sector"))
      contents = content_api.with_tag(slug, "specialist_sector")
      return self.new(sector, contents)
    else
      return nil
    end
  end

  def initialize(sector, contents)
    @sector = sector
    @contents = contents
  end

  def title
    @sector["title"]
  end

  def parent
    @sector["parent"].with_indifferent_access
  end

  def results
    @contents["results"].map(&:with_indifferent_access)
  end
end
