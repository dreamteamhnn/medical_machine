class CreateCustomerOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_orders do |t|
      t.references :product, foreign_key: true
      t.string :customer_name
      t.string :phone_number
      t.string :email
      t.string :shipping_address
      t.string :billing_address

      t.timestamps
    end
  end
end
