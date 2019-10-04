class AddImageFieldsToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :img_1_title, :string
    add_column :products, :img_1_desc, :string
    add_column :products, :img_1_caption, :string
    add_column :products, :img_1_alt, :string
    add_column :products, :img_2_title, :string
    add_column :products, :img_2_desc, :string
    add_column :products, :img_2_caption, :string
    add_column :products, :img_2_alt, :string
  end
end
