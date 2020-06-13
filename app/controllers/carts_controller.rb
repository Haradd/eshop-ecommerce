class CartsController < ApplicationController

  def index
    products_ids = cookies['cart']&.split(' ')
    @products = Product.where(id: products_ids)
  end
end
