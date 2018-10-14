class Admin::BrandsController < Admin::BaseController
  before_action :load_brands, only: [:index]

  def index
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)
    if @brand.save
      flash[:success] = "Tạo mới hãng #{@brand.name} thành công!"
    else
      flash[:danger] = "Lỗi! Tạo mới hãng không thành công."
    end
    redirect_to admin_brands_path()
  end

  def update
    @brand = Brand.find_by id: params[:id]
    if params[:name] || params[:home_order] || params[:description] || params[:location]
      if @brand
        @brand.update_attributes(name: params[:name], home_order: params[:home_order],
          description: params[:description], location: params[:location])
      end

      if request.xhr?
        render json: {
          name: @brand.name,
          location: @brand.location,
          home_order: @brand.home_order,
          description: @brand.description
        }
      end
    end

    if params[:image]
      if @brand
        @brand.image =  params[:image]
        @brand.save
      end
      if request.xhr?
        render json: {
          src: @brand.image.url
        }
      end
    end
  end

  def destroy
    brand = Brand.find_by id: params[:id]
    if brand
      brand_name = brand.name
      brand.products.destroy_all
      if brand.destroy
        flash[:success] = "Xóa hãng #{brand_name} thành công!"
      else
        flash[:danger] = "Lỗi! Xóa hãng không thành công."
      end
    end
    redirect_to admin_brands_path()
  end

  private
  def load_brands
    @brands = Brand.all.order(created_at: :desc)
  end

  def brand_params
    params.require(:brand).permit(Brand::BRAND_ATTRIBUTES)
  end
end
