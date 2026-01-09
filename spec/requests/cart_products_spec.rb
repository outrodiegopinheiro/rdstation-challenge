require 'rails_helper'

RSpec.describe "/cart_products", type: :request do
  let(:product) {
    Product.create(name: 'Samsung Galaxy S24 Ultra', unit_price: 12999.99)
  }

  let(:valid_attributes) {
    {
      product_id: product.id,
      quantity: 4
    }
  }

  let(:invalid_attributes) {
    {
      product_id: product.id,
      quantity: -4
    }
  }

  let(:valid_headers) {
    {}
  }

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a CartProduct" do
        expect {
          post '/cart',
               params: valid_attributes, headers: valid_headers, as: :json
        }.to change(CartProduct, :count).by(1)
      end

      it "renders a JSON response with the cart" do
        post '/cart',
             params: valid_attributes, headers: valid_headers, as: :json

        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a CartProduct" do
        expect {
          post '/cart',
               params: invalid_attributes, as: :json
        }.to change(CartProduct, :count).by(0)
      end

      it "renders a JSON response with errors for the new CartProduct" do
        post '/cart',
             params: invalid_attributes, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PUT /cart/add_item" do
    context 'when the product already is in the cart' do
      it 'updates the quantity of the existing item in the cart' do
        post '/cart', params: valid_attributes, headers: valid_headers, as: :json

        put '/cart/add_item', params: { product_id: product.id, quantity: 3 }, as: :json
        put '/cart/add_item', params: { product_id: product.id, quantity: 4 }, as: :json

        body = JSON.parse(response.body)

        expect(body.keys).to eq(%w[id products total_price])

        products = body['products']

        expect(products.count).to eq(1)
        expect(products.first['quantity']).to eq(4)
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors" do
        post '/cart', params: valid_attributes, headers: valid_headers, as: :json

        put '/cart/add_item', params: { product_id: product.id, quantity: 3 }, as: :json
        put '/cart/add_item', params: { product_id: product.id, quantity: 'w' }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "remove the product from cart" do
      post '/cart', params: valid_attributes, headers: valid_headers, as: :json

      expect {
        delete "/cart/#{product.id}", headers: valid_headers, as: :json
      }.to change(CartProduct, :count).by(-1)
    end
  end
end
