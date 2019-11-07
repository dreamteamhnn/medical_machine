class Admin::FeedbacksController < Admin::BaseController

  before_action :load_feedback, only: [:edit, :update, :destroy]

  def index
    @feedbacks = Feedback.all.page(params[:page]).per(params[:per_page])
  end

  def new
      @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    if @feedback.save
        flash[:success] = "Tạo mới danh mục #{@feedback.name} thành công!"
        redirect_to admin_feedbacks_url
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
    redirect_to admin_feedbacks_path()
  end

  private

  def load_feedback
    @feedback = Feedback.find(params[:id]) if params[:id].present?
  end

  def feedback_params
    params.require(:feedback).permit(Feedback::FEEDBACK_ATTRIBUTES)
  end
end