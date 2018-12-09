class Admin::CustomerOrdersController < Admin::BaseController
  before_action :load_order, only: [:destroy, :confirm_delete]

  def index
    @orders = CustomerOrder.all.includes(:product).order(created_at: :desc)
      .page(params[:page]).per params[:per_page]
  end

  def confirm_delete
  end

  def destroy
    if @order.destroy
      flash.now[:success] = "Xóa đơn hàng thành công"
    else
      flash.now[:success] = "Xóa đơn hàng không thành công"
    end
  end

  def confirm_bulk_delete
    if params[:order_ids].blank?
      flash.now[:danger] = "Vui lòng chọn ít nhất 1 đơn hàng để xóa"
    end
  end

  def bulk_delete
    if params[:order_ids].blank?
      flash.now[:danger] = "Xóa nhiều đơn hàng không thành công. Vui lòng chọn ít nhất 1 đơn hàng để xóa "
      return @result = "error"
    end
    @result = CustomerOrder.bulk_delete_execute params[:order_ids]
    if @result[:status] == "success"
      flash.now[:success] = "Các đơn hàng đã được xóa thành công"
    else
      flash.now[:danger] = "Đã xảy ra lỗi, không thể xóa các đơn hàng được chọn. Vui lòng thử lại"
    end
  end

  private

  def load_order
    @order = CustomerOrder.find params[:id]
  end
end
