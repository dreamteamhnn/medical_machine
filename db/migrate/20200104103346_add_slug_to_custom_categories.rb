class AddSlugToCustomCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :custom_categories, :slug, :string
  end
end
