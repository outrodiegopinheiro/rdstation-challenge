require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :carts, only: %i[show] do
    resources :cart_products, only: %i[create update destroy]
  end

  resources :products

  get 'cart', to: 'carts#show'
  get "up" => "rails/health#show", as: :rails_health_check

  post 'cart', to: 'cart_products#create'
  post 'cart/add_item', to: 'cart_products#update'

  delete '/cart/:product_id', to: 'cart_products#destroy'

  root "rails/health#show"
end
