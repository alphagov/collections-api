class SectorContent
  def initialize(slug)
    content_api = CollectionsAPI.services(:content_api)
    @sector = content_api.tag(slug, "specialist_sector")
    @content = content_api.with_tag(slug, "specialist_sector")
  end

  def title
    @sector["title"]
  end

  def results
    @content["results"]
  end
end
