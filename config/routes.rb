require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :carts, only: %i[index] do
    resources :card_products, only: %i[create update]
  end

  resources :products

  get 'cart', to: 'carts#index'
  get "up" => "rails/health#show", as: :rails_health_check

  post 'cart', to: 'card_products#create'

  put 'cart/add_item', to: 'card_products#update'

  root "rails/health#show"
end
