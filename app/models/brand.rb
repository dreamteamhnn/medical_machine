class Brand < ApplicationRecord
  include FriendlyidConfiguration
  include BrandDecorator

  has_many :products, dependent: :destroy
  mount_uploader :image, ImageUploader

  BRAND_ATTRIBUTES = %i(name location description image home_order)

  validates :location, presence: true
  # validates :image, presence: true
end
