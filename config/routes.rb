require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :carts, only: %i[index]

  get 'cart', to: 'carts#index'

  resources :products
  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"
end
