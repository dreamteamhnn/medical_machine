class Admin::ImportsController < Admin::BaseController
  def new
    @excel_product = ExcelProduct.new
  end

  def create
    if params[:excel_product]
      @excel_product = ExcelProduct.new excel_product_params
      Product.import(@excel_product.file)
      flash[:success] = "Upload sản phẩm thành công!"
      redirect_to new_admin_import_path
    else
      flash[:danger] = "Upload sản phẩm không thành công!"
      @excel_product = ExcelProduct.new
      render :new
    end
  end

  def index
    if params[:ids]
      ids = params[:ids].split(",")
      @products = Product.where(id: ids)
      respond_to do |format|
        format.html
        format.xlsx {render xlsx: 'export',filename: "export_products.xlsx"}
      end
    elsif params[:delete_product_ids]
      ids = params[:delete_product_ids].split(",")
      @products = Product.where(id: ids)
      if @products
        @products.each do |p|
          p.destroy
        end
      end
      redirect_to admin_products_path()
    elsif params[:delete_brand_ids]
      ids = params[:delete_brand_ids].split(",")
      @brands = Brand.where(id: ids)
      if Product.where(brand_id: ids).count > 0
        flash[:warning] = "Không xoá được! Tồn tại sản phẩm thuộc hãng"
      else
        flash[:success] = "Xoá thành công hãng #{@brands.map(&:name).join(', ')}"
        @brands.destroy_all
      end
      redirect_to admin_brands_path()
    elsif params[:delete_field_ids]
      ids = params[:delete_field_ids].split(",")
      @fields = Field.where(id: ids)
      if Product.joins(:product_fields).where("product_fields.field_id IN (?)", ids.join(',')).count > 0
        flash[:warning] = "Không xoá được! Tồn tại sản phẩm thuộc lĩnh vực"
      else
        flash[:success] = "Xoá thành công lĩnh vực #{@fields.map(&:name).join(', ')}"
        @fields.destroy_all
      end
      redirect_to admin_fields_path()
    else
      @products = Product.order(:id).limit(1)
      respond_to do |format|
        format.html
        format.xlsx {render xlsx: 'index',filename: "new_products.xlsx"}
      end
    end
  end

  private
  def excel_product_params
    params.require(:excel_product).permit(:file)
  end
end
