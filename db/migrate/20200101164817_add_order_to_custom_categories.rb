class AddOrderToCustomCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :custom_categories, :order, :integer
  end
end
