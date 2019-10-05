class AddOrderToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :no_order, :integer
  end
end
