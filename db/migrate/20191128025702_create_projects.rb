class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :content
      t.integer :order
      t.string :slug

      t.timestamps
    end
  end
end
