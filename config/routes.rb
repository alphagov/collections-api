Rails.application.routes.draw do
  get "specialist-sectors/*id/latest-changes", to: "latest_changes#show"
  get "specialist-sectors/*id", to: "specialist_sectors#show"
  get 'healthcheck' => 'healthcheck#index'
end
