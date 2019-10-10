class ProductImage < ApplicationRecord
  # belongs_to :product

  mount_uploader :url, ImageUploader
end
