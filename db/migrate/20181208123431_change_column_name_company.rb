class ChangeColumnNameCompany < ActiveRecord::Migration[5.1]
  def change
    rename_column :companies, :address, :hn_address
  end
end
