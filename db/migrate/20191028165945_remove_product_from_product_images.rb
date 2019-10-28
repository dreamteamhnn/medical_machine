class RemoveProductFromProductImages < ActiveRecord::Migration[5.1]
  def change
    remove_reference :product_images, :product, foreign_key: true
  end
end
