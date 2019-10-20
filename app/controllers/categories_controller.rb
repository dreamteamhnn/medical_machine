class CategoriesController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  before_action :load_left_menu_by_category, only: :index

  ORDER_ATTRS = %i(username phone email received_address pay_address)

  def index
    @top_categories = Category.top_categories
    @brand_logos = Brand.where("image IS NOT NULL AND home_order IS NOT NULL")
                        .order(:home_order)
  end

  private
  def load_left_menu_data is_current_category = false
    mang_ong = []
    ongs = Category.where(level: Settings.category.highest_level)
    if is_current_category
      ongs = Category.where(id: @category_lv_1.id)
    end
    ongs.each do |ong|
      bos = ong.childrens
      mang_bo = []
      bos.each do |bo|
        mang_con = bo.childrens
        mang_bo << [bo, mang_con]
      end
      mang_ong << [ong, mang_bo]
    end
    @categories = mang_ong
    load_breadcrum
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
        @breads << {title: parent.name, link: products_path(category_id: parent.id)}
        if grand_parent = parent.parents.first
          @breads << {title: grand_parent.name, link: products_path(category_id: grand_parent.id)}
        end
      end
      @breads << {title: "Tất cả sản phẩm", link: all_products_path}
      @breads = @breads.reverse
    elsif params[:id]
      @breads = [{title: strip_tags(@product.name), link: ""}]
      if category = @product.categories.first
        @breads << {title: category.name, link: products_path(category_id: category.id)}
        if parent = category.parents.first
          @breads << {title: parent.name, link: products_path(category_id: parent.id)}
          if grand_parent = parent.parents.first
            @breads << {title: grand_parent.name, link: products_path(category_id: grand_parent.id)}
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
      @breads = [{title: "Tất cả sản phẩm", link: ""}]
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

  def order_params
    params.permit ORDER_ATTRS
  end
end
