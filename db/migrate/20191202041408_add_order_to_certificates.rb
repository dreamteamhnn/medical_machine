class AddOrderToCertificates < ActiveRecord::Migration[5.1]
  def change
    add_column :certificates, :order, :integer
  end
end
