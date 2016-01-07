Rails.application.routes.draw do

  root 'users#feed'
  
  get "/auth/:provider/callback" => "sessions#create"
  get "/login" => "sessions#new", as: :login
  delete "/logout/"              => "sessions#destroy", as: :logout
  get "/search/"                => "creators#search"
  resources :users, only: [:show, :delete, :create]

end
