class CartsController < ApplicationController
  ## TODO Escreva a lógica dos carrinhos aqui

  def index
    cart = current_cart
    response = {
      id: cart.id,
      products: cart.products,
      total_price: cart.total_price
    }

    render json: response
  end
end
