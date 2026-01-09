require 'rails_helper'

RSpec.describe CartProduct, type: :model do
  context 'when validating' do
    it 'validates numericality of quantity' do
      cart_product = described_class.new(quantity: -1)

      expect(cart_product.valid?).to be_falsey
      expect(cart_product.errors[:quantity]).to include("must be greater than or equal to 1")

      cart_product = described_class.new(quantity: '-1')

      expect(cart_product.valid?).to be_falsey
      expect(cart_product.errors[:quantity]).to include("must be greater than or equal to 1")
    end
  end
end
