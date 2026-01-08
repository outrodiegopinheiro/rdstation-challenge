class CartsController < ApplicationController
  ## TODO Escreva a lógica dos carrinhos aqui

  def index
    render json: build_cart_response(current_cart), status: 200
  end
end
