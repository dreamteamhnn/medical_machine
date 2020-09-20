class ProductsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  before_action :load_data_show, only: :show
  before_action :load_data_index, only: :index
  before_action :load_left_menu_by_category, only: [:show, :index]

  ORDER_ATTRS = %i(username phone email received_address pay_address)

  def index
    @top_categories = Category.top_categories
    @brand_logos = Brand.where("image IS NOT NULL AND home_order IS NOT NULL")
                        .order(:home_order)
    set_meta_tags meta_tags_hash_index
  end

  def show
    @top_categories = Category.top_categories
    @brand_logos = Brand.where("image IS NOT NULL AND home_order IS NOT NULL")
                        .order(:home_order)
    @blogs = Blog.new_articles_for_related
    set_meta_tags meta_tags_hash
  end

  def order
    @product = Product.friendly.find(params[:id]) if params[:id].present?
    @product = Product.find_by(slug: params[:id]) unless @product.present?
    respond_to do |format|
      format.js{render layout: false}
    end
  end

  def send_order
    @product = Product.friendly.find(params[:id]) if params[:id].present?
    @order = @product.customer_orders.build order_params
    @data_valid = @order.valid?
    @error_messages = @order.errors.messages.values.flatten unless @data_valid
    return unless @data_valid
    @order.save
    user_info = params.as_json(only: ORDER_ATTRS).symbolize_keys
    ProductOrderMailer.order(user_info, @product).deliver_later
  end

  private

  def meta_tags_hash_index
    description = @category&.description
    parent = @category&.parents&.first&.parents&.first&.name || @category&.parents&.first&.name
    keywords = [@category&.name, parent, "Stech Sài Gòn"]
    if @category&.level == 2
      description = 'Bể rửa siêu âm nhập khẩu chính hãng bởi Stech Sài Gòn. Sản phẩm đa dạng - Hàng có sẵn tại Hà Nội và HCM. Cam kết: Giao hàng nhanh nhất - Giá tốt nhất - Bảo hành trên 12 tháng!'
      keywords = [@category.name] + @category&.childrens.pluck(:name) + ["Stech Sài Gòn"]
    elsif @category&.level == 3
      description = 'Bể rửa siêu âm nhập khẩu chính hãng bởi Stech Sài Gòn. Sản phẩm đa dạng - Hàng có sẵn tại Hà Nội và HCM. Cam kết: Giao hàng nhanh nhất - Giá tốt nhất - Bảo hành trên 12 tháng!'
      keywords = [@category.name, @category&.parents&.first&.name, @category&.parents&.first&.parents&.first&.name ,"Stech Sài Gòn"]
    end
    {
      description: description&.html_safe,
      keywords: keywords,
      index: true,
      og: {
        title: I18n.t("site_name"),
        type: "article",
        description: description&.html_safe,
        url: request.url,
        site_name: I18n.t('site_name')
      },
      twitter: {
        card: "summary",
        site: "@publisher_handle",
        title: I18n.t("site_name"),
        description: description&.html_safe,
        creator: "@author_handle",
      }
    }
  end

  def meta_tags_hash
    description = @product.description
    {
      description: @product.short_description&.html_safe,
      keywords: [@product&.name, @product.model, @product.brand&.name, @product.origin, @product.categories.first&.parents&.first&.name, 'Stech Sài Gòn'],
      index: true,
      og: {
        title: I18n.t("site_name"),
        type: "article",
        description: @product.short_description&.html_safe,
        url: request.url,
        site_name: I18n.t('site_name')
      },
      twitter: {
        card: "summary",
        site: "@publisher_handle",
        title: I18n.t("site_name"),
        description: @product.short_description&.html_safe,
        creator: "@author_handle",
      }
    }
  end

  def load_left_menu_data is_current_category = false
    mang_ong = []
    ongs = Category.where(level: Settings.category.highest_level)
    if is_current_category
      ongs = Category.where(id: @category_lv_1.id)
    end
    ongs.each do |ong|
      bos = ong.childrens.order('category_order IS NULL, category_order ASC, id ASC')
      mang_bo = []
      bos.each do |bo|
        mang_con = bo.childrens.order('category_order IS NULL, category_order ASC, id ASC')
        mang_bo << [bo, mang_con]
      end
      mang_ong << [ong, mang_bo]
    end
    @categories = mang_ong
    get_new_product
    load_breadcrum
    load_products_block
    load_brand_exist
    load_new_blogs
  end

  def load_products_block
    @childs = []
    if category = Category.find_by(id: params[:category_id])
      if category.level == Settings.category.middle_level
        if category.childrens
          @childs = []
          category.childrens.each do |child|
            products = params[:brand_id] ? child.products.order('no_order IS NULL, no_order ASC, id ASC')
              .where(brand_id: params[:brand_id]) : child.products
            if products.size > 0
              @childs << {name: child.name, id: child.id, products: products
                .order(category_order: :asc).limit(Settings.limit.product_block)}
            end
          end

        end
      elsif category.level == Settings.category.highest_level
        if category.childrens
          @childs = []
          category.childrens.each do |child|
            products = child.product_for_block_list(params[:brand_id]).order('no_order IS NULL, no_order ASC, id ASC')
            if products.size > 0
              @childs << {name: child.name, id: child.id, products: products}
            end
          end
        end
      end
      unless category.level == Settings.category.lowest_level
        @products = []
        @childs.each do |child|
          @products += child[:products]
        end
        @products = Kaminari.paginate_array(@products.flatten)
          .page(params[:page]).per(Settings.limit.paginate.products)
        limit = Settings.limit.paginate.products/Settings.limit.product_block
        page = params[:page] ? params[:page].to_i : 1
        @childs = @childs.select.with_index do |c, index|
          limit*(page-1) <= index && index <= page*limit - 1
        end
      end
    end
  end

  def load_brand_exist
    return unless @category
    @brands = Brand.where(id: list_products(@category).pluck(:brand_id).uniq)
      .order(:name)
  end

  def load_left_menu_by_category
    @category = if params[:category_id]
                  Category.find_by(slug: params[:category_id])
                elsif params[:id]
                  product = Product.find_by(slug: params[:id])
                  product&.categories&.first
                end
    return load_left_menu_data unless @category
    if @category.level == Settings.category.middle_level
      @category_lv_1 = @category&.parents&.first
    elsif @category.level == Settings.category.lowest_level
      @category_lv_1 = @category&.parents&.first&.parents&.first
    elsif @category.level == Settings.category.highest_level
      @category_lv_1 = @category
    end
    return load_left_menu_data unless @category_lv_1
    load_left_menu_data true
  end

  def load_breadcrum
    if params[:category_id]
      category = Category.friendly.find params[:category_id]
      @breads = [{title: category.name, link: ""}]
      if parent = category.parents.first
        @breads << {title: parent.name, link: category_products_path(category_id: parent.slug)}
        if grand_parent = parent.parents.first
          @breads << {title: grand_parent.name, link: category_products_path(category_id: grand_parent.slug)}
        end
      end
      # @breads << {title: "Tất cả sản phẩm", link: all_products_path}
      @breads = @breads.reverse
    elsif params[:id]
      @breads = [{title: strip_tags(@product.name), link: ""}]
      if category = @product.categories.first
        @breads << {title: category.name, link: category_products_path(category_id: category.slug)}
        if parent = category.parents.first
          @breads << {title: parent.name, link: category_products_path(category_id: parent.slug)}
          if grand_parent = parent.parents.first
            @breads << {title: grand_parent.name, link: category_products_path(category_id: grand_parent.slug)}
          end
        end
      end
      @breads = @breads.reverse
    elsif params[:brand_id]
      brand = Brand.friendly.find params[:brand_id]
      @breads = [{title: "Hãng sản xuất", link: all_products_path()}]
      @breads << {title: brand.name, link: ""}
    elsif params[:field_id]
      field = Field.friendly.find params[:field_id]
      @breads = [{title: "Lĩnh vực", link: all_products_path()}]
      @breads << {title: field.name, link: ""}
    else
      # @breads = [{title: "Tất cả sản phẩm", link: ""}]
    end
  end

  def load_data_show
    @product = Product.friendly.find(params[:id]) if params[:id].present?
    @product = Product.find_by(slug: params[:id]) unless @product.present?
    @documents = @product.mediums.where(media_type: 0)
    @videos = @product.mediums.where(media_type: 1)
    @related_products = []
    @related_products_1 = []
    @related_products_2 = []
    if category = @product.categories.try(&:second) || @product.categories.first
      @related_products = Product.where(id: category.products.pluck(:id).uniq).order("RAND()")
        .limit Settings.limit.related_products
      @related_products_1 = @related_products[0..2] if @related_products[0..3]
      @related_products_2 = @related_products[3..5] if @related_products[4..7]
    end
  end

  def load_data_index
    params[:page] ||= 1
    @limit = params[:limit] || Settings.limit.paginate.products
    menu_item = nil
    if params[:category_id]
      menu_item = Category.friendly.find params[:category_id]
    elsif params[:field_id]
      menu_item = Field.friendly.find params[:field_id]
    elsif params[:brand_id]
      menu_item = Brand.friendly.find params[:brand_id]
    end

    set_meta_tags(menu_item) if menu_item

    @products_from_menu = get_products(menu_item).order('no_order IS NULL, no_order ASC, id ASC').page(params[:page])
      .per(@limit)

    unless @products_from_menu.blank?
      @title = menu_item ? menu_item.name : "Tất cả sản phẩm"
      get_number_show_product
    end

    if (q = params[:query]).present?
      set_meta_tags noindex: true, follow: true
      found_products = Product.search(body: {query: {bool: {should: [{match: {title: q}}, {match: {category: q}}, {match: {brand: q}}, {match: {field: q}}]}}})
      @products_from_menu = get_products(Product.by_ids(found_products.map(&:id))).order('no_order IS NULL, no_order ASC, id ASC')
        .page(params[:page]).per(@limit)
      get_number_show_product if @products_from_menu.present?
    end
  end

  def get_number_show_product
    # limit = Settings.limit.paginate.products
    limit = params[:limit].to_i
    @from = (params[:page].to_i - 1) * limit + 1
    if @products_from_menu.size >= limit
      @to = params[:page].to_i * limit
    else
      @to = @products_from_menu.total_count
    end
  end

  def get_products menu_item
    products = menu_item.respond_to?(:size) ? menu_item :
      (menu_item.present? ? get_products_for_menu_item(menu_item) : Product.friendly.all)
    if params[:sort_by] == Product::SORT_FIELDS[:name]
      sort_by_price products.order(name: :asc)
    elsif params[:sort_by] == Product::SORT_FIELDS[:date]
      sort_by_price products.order(created_at: :desc)
    elsif params[:sort_by] == Product::SORT_FIELDS[:price]
      sort_by_price products.order(price: :asc)
    elsif params[:sort_by] == Product::SORT_FIELDS[:price_desc]
      sort_by_price products.order(price: :desc)
    else
      sort_by_price products
    end
  end

  def get_products_for_menu_item menu_item
    return menu_item.products unless menu_item.class.name == Category.name
    category = menu_item
    if params[:brand_id]
      list_products(category).where(brand_id: params[:brand_id])
    else
      list_products category
    end
  end

  def list_products category
    list_categories = [category.id]
    if c = category.childrens
      list_categories << c.pluck(:id)
      c.each do |children|
        if sub_c = children.childrens
          list_categories << sub_c.pluck(:id)
        end
      end
    end
    list_categories = list_categories.flatten
    Product.friendly.by_categories list_categories
  end

  def sort_by_price products
    if params[:min_price] && params[:max_price]
      products.sort_in_range [params[:min_price].to_i, params[:max_price].to_i]
    elsif params[:min_price]
      products.sort_from_price params[:min_price].to_i
    elsif params[:max_price]
      products.sort_to_price params[:max_price].to_i
    else
      products
    end
  end

  def get_new_product
    label_id = Label.where(short_title: "hot").first.id
    @new_products = Product.where(label_id: label_id).shuffle[0..4]
      .take(Settings.limit.new_products)
  end

  def load_new_blogs
    @new_blogs = Blog.all.take(Settings.limit.new_blogs)
  end

  def order_params
    params.permit ORDER_ATTRS
  end
end
