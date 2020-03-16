class ProductOrderMailer < ApplicationMailer
  def order user_info, product
    @user_info, @product = user_info, product
    mail to: "laihuutoan@gmail.com",
      subject: "<Stech Sài Gòn> Có một đơn hàng mới từ #{@user_info[:username]}"

    # mail to: @company.email,
    #   subject: "<Stech Sài Gòn> Có một đơn hàng mới từ #{@user_info[:username]}"
  end
end
