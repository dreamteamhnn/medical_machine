class Feedback < ApplicationRecord
  mount_uploader :avatar, ImageUploader

  FEEDBACK_ATTRIBUTES = %i(name company position avatar content)
end
