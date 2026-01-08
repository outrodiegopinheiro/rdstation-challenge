require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :carts, only: %i[index] do
    resources :card_products, only: %i[create]
  end

  resources :products

  get 'cart', to: 'carts#index'
  get "up" => "rails/health#show", as: :rails_health_check

  post 'cart', to: 'card_products#create'

  root "rails/health#show"
end
