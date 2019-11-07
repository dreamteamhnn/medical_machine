class Feedback < ApplicationRecord
  mount_uploader :image, ImageUploader

  BRAND_ATTRIBUTES = %i(name location description image home_order)

  validates :location, presence: true
end
