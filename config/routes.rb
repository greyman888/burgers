Rails.application.routes.draw do
  resources :items
  # Defines the root path route ("/")
  root "orders#index"

  resources :orders
  get "/new_voice_order", to: "orders#new_voice"
  resources :items
  resources :modifications
  resources :selections do
    member do
      get 'change'
    end
  end


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
