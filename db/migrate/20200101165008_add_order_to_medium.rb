class AddOrderToMedium < ActiveRecord::Migration[5.1]
  def change
    add_column :media, :order, :integer
  end
end
