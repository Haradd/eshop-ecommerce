class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all.order(created_at: :desc)
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/1/update_cart
  def add_to_cart
    product_id = params[:id].to_s
    if cookies['cart'].present?
      product_ids = cookies['cart'].split(' ').push(product_id).uniq
      cookies['cart'] = { value: product_ids.join(' ') }
    else
      cookies['cart'] = { value: product_id }
    end

    redirect_to products_path, notice: 'Product was successfully added to the cart.'
  end

  def remove_from_cart
    if cookies['cart'].present?
      product_ids = cookies['cart'].split(' ') - [params[:id].to_s]
      cookies['cart'] = { value: product_ids.join(' ') }
      redirect_to carts_path, notice: 'Product was successfully removed from the cart.'
    else
      redirect_to products_path, notice: 'Something went wrong. Please search for another product'
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :description, :price)
    end
end
