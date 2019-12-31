class Project < ApplicationRecord
  extend FriendlyId
  include ProjectDecorator

  mount_uploader :img, ImageUploader

  friendly_id :beauty_slug, use: :slugged

  PROJECT_ATTRIBUTES = [:title, :content, :order, :link, :img, :img_title, :img_alt, :img_desc, :img_caption]

  validates :title, presence: true
  validates :content, presence: true
  validates :img, presence: true
  validates :link, presence: true

  private

  def beauty_slug
    title.convert_vietnamese_to_unicode
  end
end
