class Admin::ProductsController < Admin::BaseController
  include ActionView::Helpers::SanitizeHelper

  before_action :load_products, only: :index
  before_action :load_product, only: [:new, :create, :edit, :update, :destroy]

  def index
  end

  def new
    @product = Product.new
    @product.product_categories.build
  end

  def destroy_multiple
    binding.pry
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "Tạo mới sản phẩm #{strip_tags(@product.name)} thành công!"
      redirect_to admin_products_path
    else
      @category_attrs = category_params
      @field_attrs = field_params
      @video_attrs = media_params
      @document_attrs = media_params
      flash[:danger] = @product.errors.full_messages
      render :new
    end
  end

  def edit
    @category_attrs = category_params
    @field_attrs = field_params
    @video_attrs = media_params
    @document_attrs = media_params
  end

  def update
    if @product.update_attributes(product_params)
      flash[:success] = "Sửa sản phẩm [#{strip_tags(@product.name)}] thành công!"
    else
      @category_attrs = category_params
      @field_attrs = field_params
      @video_attrs = media_params
      @document_attrs = media_params
      flash[:danger] = @product.errors.full_messages
    end
    redirect_to edit_admin_product_path(@product)
  end

  def destroy
    if @product.destroy
      flash[:success] = "Xóa sản phẩm [#{strip_tags(@product.name)}] thành công!"
    else
      flash[:danger] = "Lỗi! Xóa sản phẩm không thành công."
    end
    redirect_to admin_products_path()
  end

  def quick_save
    product = Product.find_by(id: params[:product_id])
    if product.present?
      data = JSON.parse(params[:data])
      product.name = data["name"] if data["name"].present?
      product.model = data["model"] if data["model"].present?
      product.no_order = data["order"] if data["order"].present?
      product.price = data["price"].try(&:to_i) if data["price"].present?
      product.short_description = data["short_description"] if data["short_description"].present?
      product.save
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: {status: true} }
      end
    else
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: {status: false} }
      end
    end
  end

  private

  def product_params
    params[:product][:name] = strip_tags(params[:product][:name]).strip
    # params[:product][:short_description] = strip_tags(params[:product][:short_description]).strip
    # params[:product][:description] = strip_tags(params[:product][:description]).strip
    if @product
      params[:product][:img_1_title] = "anh-#{@product.slug}" unless params[:product][:img_1_title].present?
      params[:product][:img_1_desc] = "anh-#{@product.slug}" unless params[:product][:img_1_desc].present?
      params[:product][:img_1_caption] = "#{@product.slug}-co-san-tai-stechsaigon" unless params[:product][:img_1_caption].present?
      params[:product][:img_1_alt] = "#{@product.slug}-co-san-tai-stechsaigon" unless params[:product][:img_1_alt].present?

      params[:product][:img_2_title] = "anh-#{@product.slug}" unless params[:product][:img_2_title].present?
      params[:product][:img_2_desc] = "anh-#{@product.slug}" unless params[:product][:img_2_desc].present?
      params[:product][:img_2_caption] = "#{@product.slug}-co-san-tai-stechsaigon" unless params[:product][:img_2_caption].present?
      params[:product][:img_2_alt] = "#{@product.slug}-co-san-tai-stechsaigon" unless params[:product][:img_2_alt].present?
    end

    params[:product][:parameter] = strip_tags(params[:product][:parameter]).strip
    params.require(:product).permit(Product::PRODUCT_ATTRIBUTES,
      product_categories_attributes: Product::PRODUCT_CATEGORY_ATTRIBUTES,
      product_fields_attributes: Product::PRODUCT_FIELD_ATTRIBUTES,
      product_media_relations_attributes: Product::PRODUCT_MEDIA_ATTRIBUTES)
  end

  def load_products
    get_categories
    @products = get_products_by_categories
  end

  def load_product
    @product = Product.friendly.find(params[:id]) if params[:id].present?
    get_categories
    get_fields
    get_medias
  end

  def field_params
    arr = {}
    if @product.product_fields
      @product.product_fields.each do |field|
        arr[field.field_id.to_s] = field.list_order
      end
    else
      params[:product][:product_fields_attributes].each do |key, value|
        arr[value[:field_id]] = value[:list_order]
      end
    end
    arr
  end

  def media_params
    arr = {}
    if @product.product_media_relations
      @product.product_media_relations.each do |medium|
        arr[medium.medium_id.to_s] = medium.medium_id.to_s
      end
    else
      params[:product][:product_media_relations_attributes].each do |key, value|
        arr[value[:medium_id]] = value[:medium_id]
      end
    end
    arr
  end

  def category_params
    arr = {}
    if @product.product_categories
      @g_categories.each_with_index do |c, index|
        @product.product_categories.each do |pc|
          if c.all_children_ids.include? pc.category_id
            arr[index] = {category_id: pc.category_id, list_order: pc.list_order}
            break
          end
        end
      end
    else
      @g_categories.each_with_index do |c, index|
        params[:product][:product_categories_attributes].each do |key, value|
          if c.all_children_ids.include? value[:category_id].to_i
            arr[index] = {category_id: value[:category_id].to_i, list_order: value[:list_order]}
            break
          end
        end
      end
    end
    arr
  end

  def get_fields
    @fields = Field.all.order(menu_order: :asc)
  end

  def get_medias
    @videos = Medium.where(media_type: 1)
    @documents = Medium.where(media_type: 0)
  end

  def get_categories
    @g_categories = Category.where(level: Settings.category.highest_level)
    if params[:gc_id].present?
      g_category = Category.find_by id: params[:gc_id]
      @p_categories = g_category.childrens
    else
      params[:pc_id] = params[:c_id] = nil
    end

    if params[:pc_id].present? && @p_categories.pluck(:id).include?(params[:pc_id].to_i)
      p_category = Category.find_by id: params[:pc_id]
      @categories = p_category.childrens
    else
      params[:pc_id] = params[:c_id] = nil
    end
  end

  def get_products_by_categories
    gid = params[:gc_id]
    pid = params[:pc_id]
    cid = params[:c_id]
    category_arr = []
    if gid.present? && pid.present? && cid.present?
      category_arr << gid.to_i
      category_arr << pid.to_i
      category_arr << cid.to_i
    elsif gid.present? && pid.present?
      category_arr << gid.to_i
      category_arr << pid.to_i
      category_arr << Category.find_by(id: pid).childrens.pluck(:id)
    elsif gid.present?
      category_arr << gid.to_i
      p_cates = Category.find_by(id: gid).childrens
      category_arr << p_cates.pluck(:id)
      p_cates.each do |p_id|
        category_arr << Category.find_by(id: p_id).childrens.pluck(:id)
      end
    end
    category_arr = category_arr.flatten
    params[:limit] = 5 if params[:limit] == nil
    @search = Product.all.ransack params[:q]
    return @search.result.where('name LIKE ?', "%#{params[:term]}%").page(params[:page]).per(params[:limit]) unless category_arr.size > 0
    Product.by_categories(category_arr).ransack(params[:q]).result.page(params[:page]).per(params[:limit])
  end
end
