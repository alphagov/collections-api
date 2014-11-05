require "config/initializers/services"
require "app/models/latest_changes_content"

class LatestChangesPresenter
  def initialize(slug)
    @slug = slug
  end

  def empty?
    latest_changes_content.nil? || latest_changes_content.results.blank?
  end

  def to_hash
    if empty?
      {}
    else
      latest_changes_content.results.map do |result|
        {
          details:
            {
              documents: [
                {
                  latest_change_note: result[:latest_change_note],
                  link: result[:link],
                  timestamp: result[:public_timestamp],
                  title: result[:title],
                }
              ]
            }
        }
      end
    end
  end

  def to_json
    to_hash.to_json
  end

private

  attr_reader :slug

  def latest_changes_content
    @_latest_changes_content ||= LatestChangesContent.find(slug)
  end
end
