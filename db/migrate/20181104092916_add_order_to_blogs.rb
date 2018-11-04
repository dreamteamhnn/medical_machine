class AddOrderToBlogs < ActiveRecord::Migration[5.1]
  def change
    add_column :blogs, :order, :integer
  end
end
