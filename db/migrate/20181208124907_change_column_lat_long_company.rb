class ChangeColumnLatLongCompany < ActiveRecord::Migration[5.1]
  def change
    rename_column :companies, :map_lat, :hn_map_lat
    rename_column :companies, :map_lng, :hn_map_lng
  end
end
