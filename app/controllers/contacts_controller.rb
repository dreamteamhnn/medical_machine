class ContactsController < ApplicationController
  before_action :load_breadcrumb, only: :index

  def index
    @contact = Subcriber.new
    @company = Company.first
    @top_categories = Category.top_categories
    @brand_logos = Brand.where("image IS NOT NULL AND home_order IS NOT NULL")
                        .order(:home_order)
    set_meta_tags @company
  end

  def create
    @contact = Subcriber.new(contact_params)
    if @contact.save
      flash[:success] = "Bạn đã gửi phản hồi thành công!"
    else
      flash[:danger] = "Đã có lỗi xảy ra!"
    end
    redirect_to :contacts
  end

  private
  def load_breadcrumb
    @breads = [{title: "Chỉ đường", link: ""}]
  end

  def contact_params
    params.require(:subcriber).permit(:email, :full_name, :phone, :title, :content)
  end
end
