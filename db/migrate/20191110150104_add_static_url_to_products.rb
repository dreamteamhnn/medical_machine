class AddStaticUrlToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :static_url, :string
  end
end
