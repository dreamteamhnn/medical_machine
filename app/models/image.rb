class Image < ApplicationRecord
  belongs_to :folder
  mount_uploader :image_url, NewImageUploader
end
