class ChangeStringToTextForProduct < ActiveRecord::Migration[5.1]
  def change
  	change_column :products, :name, :text
  	change_column :products, :model, :text
  	change_column :products, :location, :text
  	change_column :products, :product_type, :text
  	change_column :products, :short_description, :text
  end
end
