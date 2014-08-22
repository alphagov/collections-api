require "time"
require "active_support/core_ext/hash/indifferent_access"

class CuratedSector
  def initialize(slug)
    content_store = CollectionsAPI.services(:content_store)
    @content_item = content_store.content_item("/#{slug}")
  end

  def title
    @content_item["title"]
  end

  def description
    @content_item["description"]
  end

  def public_updated_at
    DateTime.parse(@content_item["public_updated_at"])
  end

  def groups
    @content_item["details"].with_indifferent_access[:groups]
  end
end
