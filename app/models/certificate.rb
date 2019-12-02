class Certificate < ApplicationRecord
  mount_uploader :img, ImageUploader

  CERTIFICATE_ATTRIBUTES = [:title, :img, :order]

  validates :title, presence: true
  validates :img, presence: true
end
