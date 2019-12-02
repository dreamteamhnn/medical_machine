class CreateCertificates < ActiveRecord::Migration[5.1]
  def change
    create_table :certificates do |t|
      t.string :title
      t.string :img

      t.timestamps
    end
  end
end
