class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.text :about
      t.string :phone
      t.string :work_time
      t.string :email
      t.string :facebook
      t.string :instagram
      t.string :contact_info
      t.text :address
      t.string :website

      t.timestamps
    end
  end
end
