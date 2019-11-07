class CreateCustomCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :custom_categories do |t|
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
