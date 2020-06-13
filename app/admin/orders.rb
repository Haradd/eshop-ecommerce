ActiveAdmin.register Order do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :payu_order_id, :payment_status, :details

  #
  # or
  #
  # permit_params do
  #   permitted = [:payu_order_id, :payment_status, :details]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do |f|
    f.inputs "Order Details" do
      f.input :payu_order_id
      f.input :payment_status
      f.input :details, as: :jsonb
    end
    # f.inputs :name => "Details", :for => :details do |d|
    #   d.input :name, :input_html => { :value => "#{order.details['name']}" }
    #   d.input :quantity, :input_html => { :value => "#{order.details['quantity']}" }
    #   d.input :unitPrice, :input_html => { :value => "#{order.details['unitPrice']}" }
    # end
    f.actions
  end
  
end
