class Cart < ApplicationRecord
  enum :status, { 'ACTIVE' => 0, 'ABANDONED' => 1 }.freeze

  has_many :cart_products

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  def products
    cart_products.preload(:product).all.map do |cart_product|
      product = cart_product.product

      { id: product.id, name: product.name, quantity: cart_product.quantity, unit_price: product.unit_price,
        total_price: cart_product.quantity * product.unit_price }
    end
  end

  def update_total_price!
    prices = cart_products.preload(:product).all.map do |cart_product|
      cart_product.quantity * cart_product.product.unit_price
    end

    update(total_price: prices.sum)
  end

  def update_last_interaction_at!
    update(last_interaction_at: Time.zone.now, status: 'ACTIVE')
  end
end
