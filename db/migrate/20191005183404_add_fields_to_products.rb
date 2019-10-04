class AddFieldsToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :img_1, :string
    add_column :products, :img_2, :string
  end
end
