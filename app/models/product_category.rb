class ProductCategory < ApplicationRecord
  belongs_to :product, optional: true
  belongs_to :category, optional: true

  accepts_nested_attributes_for :category
end
