class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :get_top_menu_data

  private
  def get_top_menu_data
    @subcriber = Subcriber.new
    # get_categories_anphabet
    @fields = Field.all.limit Settings.limit.product_field
    get_brands
    @service = Blog.where(is_service: true).first
    @company = Company.first
    @is_mobile = mobile_device?
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def get_categories_anphabet
    @category_array = []
    (97..122).each do |anphabet|
      category = Category.by_anphabet(anphabet.chr)
      slice_size = (category.size/Settings.limit.menu_block.a_to_z).ceil
      next unless category.present?
      @category_array << category.each_slice(slice_size).to_a
    end
  end

  def get_brands
    brands = Brand.all
    slice_size = (brands.size/Settings.limit.menu_block.brand).ceil
    @brand_array = brands.each_slice(slice_size).to_a
  end

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end.present?
  end
end
