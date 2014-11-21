Rails.application.routes.draw do
  get "specialist-sectors/*id", to: "specialist_sectors#show", id: %r{[^/]+/[^/]+}
  get 'healthcheck' => 'healthcheck#index'
end
