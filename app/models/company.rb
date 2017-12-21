class Company < ApplicationRecord
  COMPANY_ATTRIBUTES = [:name, :about, :address, :phone, :contact_info, :work_time,
    :email, :facebook, :instagram, :website, :map_lat, :map_lng, :contact_name]

  validates :name, presence: true
  validates :about, presence: true
  validates :address, presence: true
  validates :phone, presence: true
  validates :contact_info, presence: true
  validates :contact_name, presence: true
  validates :work_time, presence: true
  validates :email, presence: true

  def fanpage
    facebook.gsub "https://www.facebook.com/", ""
  end
end
