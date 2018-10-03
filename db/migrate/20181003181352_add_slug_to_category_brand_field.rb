class AddSlugToCategoryBrandField < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :slug, :string
    add_index :categories, :slug, unique: true

    add_column :fields, :slug, :string
    add_index :fields, :slug, unique: true

    add_column :brands, :slug, :string
    add_index :brands, :slug, unique: true
  end
end
