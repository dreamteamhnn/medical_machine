class AddWatermarkToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :watermark, :string
  end
end
