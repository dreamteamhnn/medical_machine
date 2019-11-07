class Admin::CategoriesController < Admin::BaseController
  before_action :load_categories, only: :index
  before_action :load_category

  def index

  end

  def update
    if @category.update_attributes(category_params)
      flash[:success] = "Sửa danh mục #{@category.name} thành công"
    else
      flash[:danger] = @category.errors.full_messages
    end
    redirect_to admin_categories_path
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      CategoryRelation.create parent_id: params[:parent_category][:id],
        children_id: @category.id
      flash[:success] = "Tạo mới danh mục #{@category.name} thành công!"
    else
      flash[:danger] = @category.errors.full_messages
    end
    redirect_to admin_categories_path
  end

  def destroy
    category_name = @category.name
    if @category.destroy
      ProductCategory.where(category_id: params[:id]).each do |pc|
        pc.destroy
      end
      CategoryRelation.where(parent_id: params[:id])
        .or(CategoryRelation.where(children_id: params[:id])).each do |cr|
          cr.destroy
      end
      flash[:success] = "Xóa danh mục #{category_name} thành công!"
    else
      flash[:danger] = @category.errors.full_messages
    end
    redirect_to admin_categories_path
  end

  private
  def category_params
    params.require(:category).permit(Category::CATEGORY_ATTRS)
  end

  def load_category
    @category = Category.find_by(id: params[:id]) || Category.new
  end

  def load_categories
    @categories = Category.where(level: Settings.category.highest_level)
      .order(:category_order)
    if @categories.count == 6
      Category.create(name: "Category 7", level: 1, category_order: 7)
      Category.create(name: "Category 8", level: 1, category_order: 8)
      @categories = Category.where(level: Settings.category.highest_level)
        .order(:category_order)
    end
  end
end
