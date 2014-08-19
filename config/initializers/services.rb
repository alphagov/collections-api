module CollectionsAPI
  def self.services(name, service = nil)
    @services ||= {}
    @services[name] = service if service
    @services[name]
  end
end
