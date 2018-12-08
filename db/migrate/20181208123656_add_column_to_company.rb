class AddColumnToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :sg_address, :string
  end
end
