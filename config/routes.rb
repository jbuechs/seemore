Rails.application.routes.draw do

  root 'feeds#index'
  get "/auth/:provider/callback" => "sessions#create"
  delete "/logout/"              => "sessions#destroy", as: :logout
  post "/search/"                => "feeds#search"


end
