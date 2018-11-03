class Admin::BlogCategoriesController < Admin::BaseController
  before_action :load_category, only: [:destroy, :update, :edit]

  def index
    @categories = Kaminari.paginate_array(BlogCategory.category_list_with_blog_count)
      .page(params[:page])
      .per(Settings.limit.paginate.admin_blog_category)
  end

  def new
    @category = BlogCategory.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @category = BlogCategory.new blog_category_params
    if @category.save
      flash[:success] = 'Thêm mới danh mục bài viết thành công'
    else
      flash[:danger] = 'Đã xảy ra lỗi, không thể tạo mới danh mục bài viết'
    end
    redirect_to admin_blog_categories_path
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if @category.update blog_category_params
      flash[:success] = 'Sửa danh mục bài viết thành công'
    else
      flash[:danger] = 'Đã xảy ra lỗi, không thể sửa danh mục bài viết'
    end
    redirect_to admin_blog_categories_path
  end

  def destroy
    @category.destroy
    flash[:success] = 'Xóa danh mục bài viết thành công'
    redirect_to admin_blog_categories_path
  end

  private

  def load_category
    @category = BlogCategory.find params[:id]
  end

  def blog_category_params
    params.require(:blog_category).permit(:name)
  end
end
