module CollectionsAPI
  def self.services(name, service = nil)
    @services ||= {}

    if service
      @services[name] = service
      return true
    else
      if @services[name]
        return @services[name]
      else
        raise ServiceNotRegisteredException.new(name)
      end
    end
  end

  class ServiceNotRegisteredException < Exception; end
end

require 'gds_api/content_store'
CollectionsAPI.services(:content_store, GdsApi::ContentStore.new(Plek.new.find('content-store')))

require 'gds_api/content_api'
CollectionsAPI.services(:content_api, GdsApi::ContentApi.new(Plek.new.find('contentapi')))

require 'gds_api/rummager'
CollectionsAPI.services(:rummager, GdsApi::Rummager.new(Plek.new.find('search')))
