class ApplicationController < ActionController::API
  protected

  def current_cart
    return @current_cart if @current_cart

    if session[:cart_id]
      @current_cart = Cart.find_by(id: session[:cart_id])
    else
      @current_cart = Cart.create(total_price: 0)

      session[:cart_id] = @current_cart.id
    end

    @current_cart
  end

  def build_cart_response(cart)
    {
      id: cart&.id,
      products: cart&.products,
      total_price: cart&.total_price
    }
  end
end
