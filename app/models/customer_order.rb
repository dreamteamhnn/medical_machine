class CustomerOrder < ApplicationRecord
  alias_attribute :username, :customer_name
  alias_attribute :phone, :phone_number
  alias_attribute :received_address, :shipping_address
  alias_attribute :pay_address, :billing_address

  belongs_to :product

  validates :customer_name, :phone_number, :email, :shipping_address, :billing_address, presence: true
  validates :email, {format: Settings.email_regex, allow_blank: true}
  validates :customer_name, length: {mininum: 2, maximum: 20}
  validates :shipping_address, :billing_address, length: {mininum: 10, maximum: 150}

  paginates_per Settings.limit.paginate.admin_customer_order

  class << self
    def bulk_delete_execute(ids)
      self.transaction do
        ids.each do |id|
          self.find(id).destroy
        end
      end
      {status: "success"}
    rescue
      {status: "error"}
    end
  end
end
