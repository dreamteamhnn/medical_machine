class Field < ApplicationRecord
  include FriendlyidConfiguration
  include FieldDecorator

  has_many :product_fields, dependent: :destroy
  has_many :products, through: :product_fields
  has_many :media, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
