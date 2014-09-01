Rails.application.routes.draw do
  get "specialist-sectors/*id", to: "specialist_sectors#show"
end
