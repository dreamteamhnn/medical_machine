class Admin::CustomCategoriesController < Admin::BaseController

	before_action :load_custom_category, only: [:edit, :update, :destroy]

	def index
		@custom_categories = CustomCategory.all.page(params[:page]).per(params[:per_page])
	end

	def new
	    @custom_category = CustomCategory.new
	end

	def create
		@custom_category = CustomCategory.new(custom_category_params)
		if @custom_category.save
	      flash[:success] = "Tạo mới danh mục #{@custom_category.name} thành công!"
	      redirect_to admin_custom_categories_path
	    else
	      flash[:danger] = @custom_category.errors.full_messages
	      render :new
	    end
	end

	def edit
	end

	def update
	  if @custom_category.update_attributes(custom_category_params)
	    flash[:success] = "Sửa danh mục #{@custom_category.name} thành công!"
	  else
	    flash[:danger] = @custom_category.errors.full_messages
	  end
	  redirect_to edit_admin_custom_category_path(@custom_category)
	end

	def destroy
	  if @custom_category.destroy
	    flash[:success] = "Xóa danh mục #{@custom_category.name} thành công!"
	  else
	    flash[:danger] = "Lỗi! Xóa danh mục không thành công."
	  end
	  redirect_to admin_custom_categories_path()
	end

	private

	def load_custom_category
		@custom_category = CustomCategory.find(params[:id]) if params[:id].present?
	end

	def custom_category_params
		params.require(:custom_category).permit(CustomCategory::CUSTOM_CATEGORY_ATTRIBUTES)
	end
end