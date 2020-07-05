class AddMetaToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :meta_description, :text
    add_column :categories, :meta_keyword, :text
  end
end
