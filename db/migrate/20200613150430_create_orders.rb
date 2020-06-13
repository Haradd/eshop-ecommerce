class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :payu_order_id
      t.string :payment_status
      t.jsonb :details, default: {}

      t.timestamps
    end
  end
end
