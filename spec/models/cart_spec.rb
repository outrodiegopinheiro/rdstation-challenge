require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)

      expect(cart.valid?).to be_falsey
      expect(cart.errors[:total_price]).to include("must be greater than or equal to 0")
    end
  end

  describe 'mark_as_abandoned' do
    let(:shopping_cart) { Cart.create(total_price: 0) }

    it 'marks the shopping cart as abandoned if inactive for a certain time' do
      shopping_cart.update(last_interaction_at: 3.hours.ago)

      expect { shopping_cart.mark_as_abandoned }.to change { shopping_cart.abandoned? }.from(false).to(true)
    end
  end

  describe 'remove_if_abandoned' do
    let(:shopping_cart) { Cart.create(total_price: 0, last_interaction_at: 7.days.ago) }

    it 'removes the shopping cart if abandoned for a certain time' do
      shopping_cart.mark_as_abandoned

      expect { shopping_cart.remove_if_abandoned }.to change { Cart.count }.by(-1)
    end
  end

  describe 'products' do
    let(:cart) { Cart.create(total_price: 0) }

    context 'with a empty response' do
      it 'return a empty list' do
        expect(cart.products).to eq([])
      end
    end

    context 'with a non empty response' do
      let!(:product) { Product.create(name: 'name', unit_price: 123) }
      let!(:cart_product1) { CartProduct.create(cart: cart, product: product) }
      let!(:cart_product2) { CartProduct.create(cart: cart, product: product) }

      it 'return a non empty list' do
        expect(cart.products.count).to eq(2)
      end
    end
  end

  describe 'total_price' do
    let(:cart) { Cart.create(total_price: 0) }

    it 'current value is zero' do
      cart.update_total_price!

      expect(cart.total_price).to eq(0)
    end

    context 'update' do
      let!(:product) { Product.create(name: 'name', unit_price: 1234) }
      let!(:cart_product1) { CartProduct.create(cart: cart, product: product, quantity: 4) }

      it 'current value is non zero' do
        cart.update_total_price!

        expect(cart.total_price).to eq(0.4936e4)
      end
    end
  end

  describe 'last_interaction_at' do
    let(:cart) { Cart.create(total_price: 0) }

    it 'current value is null' do
      expect(cart.last_interaction_at).to eq(nil)
    end

    context 'update' do
      it 'current value is non nil' do
        cart.update_last_interaction_at!

        expect(cart.last_interaction_at).not_to eq(nil)
      end
    end
  end
end
