class AddImgToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :img, :string
    add_column :projects, :img_title, :string
    add_column :projects, :img_alt, :string
    add_column :projects, :img_desc, :string
    add_column :projects, :img_caption, :string
  end
end
