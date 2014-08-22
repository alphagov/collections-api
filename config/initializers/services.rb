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
