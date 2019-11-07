class Admin::FeedbacksController < Admin::BaseController

  before_action :feedback, only: [:edit, :update, :destroy]

  def index
    @feedbacks = CustomCategory.all.page(params[:page]).per(params[:per_page])
  end

  def new
      @feedback = CustomCategory.new
  end

  def create
    @feedback = CustomCategory.new(feedback_params)
    if @feedback.save
        flash[:success] = "Tạo mới danh mục #{@feedback.name} thành công!"
        redirect_to admin_feebacks_path
      else
        flash[:danger] = @feedback.errors.full_messages
        render :new
      end
  end

  def edit
  end

  def update
    if @feedback.update_attributes(feedback_params)
      flash[:success] = "Sửa danh mục #{@feedback.name} thành công!"
    else
      flash[:danger] = @feedback.errors.full_messages
    end
    redirect_to edit_admin_feedback_path(@feedback)
  end

  def destroy
    if @feedback.destroy
      flash[:success] = "Xóa danh mục #{@feedback.name} thành công!"
    else
      flash[:danger] = "Lỗi! Xóa danh mục không thành công."
    end
    redirect_to admin_feebacks_path()
  end

  private

  def load_feedback
    @feedback = CustomCategory.find(params[:id]) if params[:id].present?
  end

  def feedback_params
    params.require(:feedback).permit(CustomCategory::CUSTOM_CATEGORY_ATTRIBUTES)
  end
end