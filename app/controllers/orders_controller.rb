require 'net/http'
require 'uri'

class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token


  # POST
  def create
    clear_cart
    access_token = get_access_token
    sum_up_products

    response = create_payment(access_token)

    payu_order_id = response['orderId']

    Order.create(payu_order_id: response['orderId'],
                 payment_status: 'INITIALIZED',
                 details: @products_details)


    redirect_to response['redirectUri']
  end

  # POST - callback endpoint that receives payments status updates from PayU
  def notify
    payu_order_id = params['order']['orderId']
    order = Order.find_by(payu_order_id: payu_order_id)

    if order.present?
      order.update(payment_status: params['order']['status'])
    end

  end

  private

  def clear_cart
    cookies.delete :cart
  end

  def sum_up_products

    products_ids = params['quantity'].keys
    products = Product.where(id: products_ids)

    @total_amount = 0.0
    @products_details = products.map do |product|
      quantity = params['quantity'][product.id.to_s]
      @total_amount += (product.price * quantity.to_i).to_d

      {
        'name' => product.name,
        'unitPrice' => convert_to_pln_in_gr(product.price),
        'quantity' => quantity
      }
    end
  end

  def convert_to_pln_in_gr(amount)
    (amount * 100).to_s.delete_suffix('.0')
  end

  def get_access_token
    uri = URI.parse("https://private-anon-55340bc7ef-payu21.apiary-mock.com/pl/standard/user/oauth/authorize")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/x-www-form-urlencoded"
    request.set_form_data(
      "client_id" => ENV['PAYU_CLIENT_ID'],
      "client_secret" => ENV['PAYU_CLIENT_SECRET'],
      "grant_type" => "client_credentials",
    )

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    JSON.parse(response.body)['access_token']
  end

  def create_payment(access_token)
    uri = URI.parse("https://secure.payu.com/api/v2_1/orders/")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer #{access_token}"
    request.body = JSON.dump({
      "notifyUrl" => "#{ENV['APP_URL']}/orders/notify",
      "continueUrl" => "#{ENV['APP_URL']}/products",
      "customerIp" => "127.0.0.1",
      "merchantPosId" => '145227',
      "description" => "e-shop",
      "currencyCode" => "PLN",
      "totalAmount" => convert_to_pln_in_gr(@total_amount),
      "products" => @products_details
    })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end
end
