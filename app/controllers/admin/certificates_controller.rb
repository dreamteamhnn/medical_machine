class Admin::CertificatesController < Admin::BaseController
  before_action :load_certificate, only: [:show, :edit, :update, :destroy]
  before_action :load_certificates, only: [:index]

  def index
    
  end

  def new
    @certificate = Certificate.new
  end

  def create
    @certificate = Certificate.new(certificate_params)
    if @certificate.save
      flash[:success] = "Thêm mới thành công"
      redirect_to admin_certificates_path()
    else
      flash[:danger] = @certificate.errors.full_messages
      render :new
    end
  end

  def edit
    
  end

  def update
    if @certificate.update_attributes(certificate_params)
      flash[:success] = "Chỉnh sửa thàng công"
      redirect_to admin_certificates_path()
    else
      flash[:danger] = @certificate.errors.full_messages
      render :edit
    end
  end

  def destroy
    if @certificate
      certificate_title = @certificate.title
      if @certificate.destroy
        flash[:success] = "Xóa chứng chỉ - ủy quyền #{certificate_title} thành công!"
      else
        flash[:danger] = @certificate.errors.full_messages
      end
    end
    redirect_to admin_certificates_path
  end

  private

  def load_certificates
    @certificates = Certificate.order(order: :desc)
  end

  def load_certificate
    @certificate = Certificate.find params[:id]
  end

  def certificate_params
    params.require(:certificate).permit(Certificate::CERTIFICATE_ATTRIBUTES)
  end
end
