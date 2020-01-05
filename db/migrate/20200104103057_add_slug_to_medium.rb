class AddSlugToMedium < ActiveRecord::Migration[5.1]
  def change
    add_column :media, :slug, :string
  end
end
