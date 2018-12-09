class ProductOrderMailer < ApplicationMailer
  def order user_info, product
    @user_info, @product = user_info, product
    mail to: "thietbistech@gmail.com",
      subject: "<Thiết bị y tế> Có một đơn hàng mới từ #{@user_info[:username]}"
  end
end
