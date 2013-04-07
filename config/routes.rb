Contwinue::Application.routes.draw do
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match '/auth/failure', to: 'sessions#destroy', via: [:get]
  get "/logout" => "sessions#destroy", as: :logout

  get 'home/index', as: :home
  match "/tweet" => "tweets#tweet", as: :tweet, via: [:get, :post]
  resource :preferences

  root to: 'home#index'
end
