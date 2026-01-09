class CartsController < ApplicationController
  def show
    render json: build_cart_response(current_cart), status: 200
  end
end
