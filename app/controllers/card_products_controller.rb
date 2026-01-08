class CardProductsController < ApplicationController
  before_action :set_product, only: %i[create update destroy]
  before_action :validate_product, only: %i[create update destroy]
  before_action :set_card_product, only: %i[update destroy]
  before_action :test_exists_in_cart, only: %i[update destroy]

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

  def update
    if @card_product.update(quantity: card_product_params[:quantity])
      cart = current_cart

      cart.update_total_price!

      render json: build_cart_response(cart), status: 200
    else
      render json: @card_product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @card_product.destroy!

    cart = current_cart

    cart.update_total_price!

    render json: build_cart_response(cart), status: 200
  end

  private

  def set_product
    @product = Product.find_by(id: card_product_params[:product_id])
  end

  def validate_product
    return render json: { error: 'Product not found' }, status: 404 if @product.blank?
  end

  def set_card_product
    @card_product = current_cart.cart_products.find_by(product: @product)
  end

  def test_exists_in_cart
    return render json: { error: "The Product don't exists in cart" }, status: 422 if @card_product.blank?
  end

  def card_product_params
    params.permit(:product_id, :quantity)
  end
end
