require "rails_helper"

RSpec.describe CartProductsController, type: :routing do
  describe 'routes' do
    it 'routes to #create' do
      expect(post: '/cart').to route_to('cart_products#create')
    end

    it 'routes to #add_item via POST' do
      expect(post: '/cart/add_item').to route_to('cart_products#update')
    end

    it 'routes to remove product via DELETE' do
      expect(delete: '/cart/1').to route_to('cart_products#destroy', product_id: '1')
    end
  end
end
