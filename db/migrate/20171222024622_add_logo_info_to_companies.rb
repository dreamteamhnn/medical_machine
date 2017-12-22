class AddLogoInfoToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :logo_title, :string
    add_column :companies, :logo_alt, :string
  end
end
