module ProductDecorator
  extend ActiveSupport::Concern

  def showed_price
    return "LIÊN HỆ" unless discount_price.present? && price.present?
    "#{discount_price_currency || price_currency}VNĐ"
  end
end
