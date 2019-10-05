class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.string :image_url
      t.integer :imageable_id
      t.string :imageable_type
      t.integer :folder_id

      t.timestamps
    end
  end
end
