class AddMetaToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :meta_title, :string
  end
end
