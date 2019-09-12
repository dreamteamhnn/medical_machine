class AddPhoneNumberToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :order_phone, :string
    add_column :companies, :sg_phone, :string
    add_column :companies, :hn_phone, :string
  end
end
