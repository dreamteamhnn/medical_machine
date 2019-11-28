class Admin::SlidersController < Admin::BaseController
  before_action :load_sliders, only: :index
  before_action :load_slider, only: [:edit, :update, :destroy]

  def index
  end

  def edit
  end

  def update
    if @slider.update_attributes(slider_params)
      flash[:success] = "Chỉnh sửa thàng công"
      redirect_to admin_sliders_path(is_edit: true)
    else

    end

  end

  def new
    @slider = SliderCatalog.new
  end

  def create
    @slider = SliderCatalog.create(slider_params.merge(image_type: "slider"))
    if @slider.valid?
      flash[:success] = "Thêm mới thàng công"
      redirect_to admin_sliders_path(is_new: true)
    else
      flash[:danger] = @slider.errors.full_messages
      render :new
    end
  end

  def destroy
    if @slider
      slider_title = @slider.title
      if @slider.destroy
        flash[:success] = "Xóa slider #{slider_title} thành công!"
      else
        flash[:danger] = @slider.errors.full_messages
      end
    end
    redirect_to admin_sliders_path
  end

  private
  def load_slider
    @slider = SliderCatalog.find_by id: params[:id]
  end

  def load_sliders
    @sliders = SliderCatalog.where(image_type: "slider")
    if params[:is_new]
      @sliders = @sliders.order(created_at: :desc)
    elsif params[:is_edit]
      @sliders = @sliders.order(updated_at: :desc)
    end
  end

  def slider_params
    params.require(:slider_catalog).permit(SliderCatalog::SLIDER_CATALOG_ATTRIBUTES)
  end
end
