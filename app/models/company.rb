class Company < ApplicationRecord
  include CompanyDecorator

  mount_uploader :logo, ImageUploader
  mount_uploader :watermark, ImageUploader

  COMPANY_ATTRIBUTES = [:name, :about, :hn_address, :sg_address, :phone, :hn_phone, :sg_phone, :order_phone, :contact_info, :work_time,
    :email, :facebook, :instagram, :website, :hn_map_lat, :hn_map_lng, :contact_name, :logo,
    :logo_title, :logo_alt, :watermark, :sg_map_lat, :sg_map_lng]

  validates :name, presence: true
  validates :about, presence: true
  validates :hn_address, presence: true
  validates :sg_address, presence: true
  validates :phone, presence: true
  validates :contact_info, presence: true
  validates :contact_name, presence: true
  validates :work_time, presence: true
  validates :email, presence: true

  def fanpage
    facebook.gsub "https://www.facebook.com/", ""
  end

  def mark
    site_name = website.sub(/^https?\:\/\//, '').sub(/^www./,'').gsub("/", '')
    "#{site_name}\n#{contact_name}: #{phone}"
  end
end
