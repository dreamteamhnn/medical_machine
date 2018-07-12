class Brand < ApplicationRecord
  has_many :products
  mount_uploader :image, ImageUploader

  BRAND_ATTRIBUTES = %i(name location description image home_order)

  validates :name, presence: true
  validates :location, presence: true
  # validates :image, presence: true
end
