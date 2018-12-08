class Admin::BlogsController < Admin::BaseController
  before_action :load_blog, only: [:show, :edit, :update, :destroy]
  before_action :load_blog_source, only: [:edit, :new]

  def index
    @blogs = Blog.all.includes(:feature_images, :blog_categories)
      .page(params[:page]).per(params[:per_page]).order "created_at DESC"
    if params[:keyword]
      @blogs = @blogs.by_keyword params[:keyword]
    end
  end

  def show
  end

  def new
    @blog = Blog.new
    @blog.blog_images.build
  end

  def create
    @blog = Blog.new blog_params
    if @blog.save
      flash[:success] = "Thêm bài viết thành công!"
      redirect_to admin_blogs_path
    else
      load_blog_source
      @blog = Blog.new
      @blog.blog_images.build
      flash.now[:danger] = "Lỗi! Thêm bài viết không thành công."
      render :new
    end
  end

  def edit
  end

  def update
    if @blog.update blog_params
      flash[:success] = "Sửa bài viết thành công!"
      redirect_to admin_blog_path(@blog)
    else
      flash.now[:danger] = "Lỗi! Sửa bài viết không thành công."
      load_blog
      load_blog_source
      render :edit
    end
  end

  def destroy
    if @blog.destroy
      flash[:success] = "Xóa bài viết thành công!"
    else
      flash[:danger] = "Lỗi! Xóa bài viết không thành công."
    end
    redirect_to admin_blogs_path
  end

  def bulk_delete
    unless params[:blog_ids].present?
      flash[:danger] = "Không có bài viết nào được chọn để xóa, vui lòng chọn các bài viết trước khi xóa"
      redirect_to admin_blogs_path and return
    end
    result = Blog.bulk_delete_execute params[:blog_ids]
    if result[:ok]
      flash[:success] = "Xóa các bài viết thành công"
    else
      flash[:danger] = result[:error_msg]
    end
    redirect_to admin_blogs_path
  end

  private
  def blog_params
    params.require(:blog).permit(:title, :content,
      :is_important, :is_service, :relation_blog_id_1, :order,
      :relation_blog_id_2, blog_category_ids: [],
      blog_images_attributes: [:id, :url, :is_feature, :_destroy])
  end

  def load_blog
    @blog = Blog.friendly.find params[:id]
  end

  def load_blog_source
    # @template_options = Template.all.pluck :name, :id
    @blog_categories = BlogCategory.all
    @blogs = Blog.all.order :title
  end
end
