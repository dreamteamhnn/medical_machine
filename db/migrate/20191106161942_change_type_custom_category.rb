class ChangeTypeCustomCategory < ActiveRecord::Migration[5.1]
  def change
    rename_column :custom_categories, :type, :custom_type
  end
end
