class AddMediaAssociationToCustomCategory < ActiveRecord::Migration[5.1]
  def self.up
    add_column :media, :custom_category_id, :integer
    add_index 'media', ['custom_category_id'], :name => 'index_custom_category_id' 
end

def self.down
    remove_column :media, :custom_category_id
end
end
