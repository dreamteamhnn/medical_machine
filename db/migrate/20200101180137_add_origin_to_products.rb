class AddOriginToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :origin, :string
  end
end
