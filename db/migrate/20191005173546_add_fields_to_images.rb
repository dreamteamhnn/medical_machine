class AddFieldsToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :title, :string
    add_column :images, :desc, :string
    add_column :images, :caption, :string
    add_column :images, :alt, :string
  end
end
