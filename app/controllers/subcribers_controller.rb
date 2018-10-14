class SubcribersController < ApplicationController
  def create
    @subcriber = Subcriber.new(subcriber_params)
    if @subcriber.save
      flash[:success] = "Đăng ký thành công!"
    else
      flash[:danger] = "Đã có lỗi xảy ra"
    end
    redirect_to request.referer
  end

  private
  def subcriber_params
    params.require(:subcriber).permit(:email)
  end
end
