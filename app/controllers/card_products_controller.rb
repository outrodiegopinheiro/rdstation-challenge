class CardProductsController < ApplicationController
  before_action :set_product, only: %i[create]
  before_action :validate_product, only: %i[create]

  def create
    cart = current_cart
    @card_product = CartProduct.new(cart: cart, product: @product, quantity: card_product_params[:quantity])

    if @card_product.save
      cart.update_total_price!

      render json: build_cart_response(cart), status: :created
    else
      render json: @card_product.errors, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find_by(id: card_product_params[:product_id])
  end

  def validate_product
    return render json: { error: 'Product not found' }, status: 404 if @product.blank?
  end

  def card_product_params
    params.permit(:product_id, :quantity)
  end
end
