class AddColumnsToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :sg_map_lat, :float
    add_column :companies, :sg_map_lng, :float
  end
end
