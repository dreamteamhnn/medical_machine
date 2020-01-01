class AddOrderToBlogCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :blog_categories, :order, :integer
  end
end
