class Admin::MediasController < Admin::BaseController

  before_action :load_doc, only: [:edit, :update]

  def index
    filter_media_param = params[:filter_video_field] || params[:filter_doc_field]
    if filter_media_param.present?
      @medias = Medium.where("media_type = ? AND field_id = ?", params[:media_type], filter_media_param)
    else
      @medias = Medium.where("media_type = ?", params[:media_type])
    end
    @video = Medium.new(media_type: "1")
  end

  def new
    @doc = Medium.new(media_type: "0")
  end

  def create
    if params[:medium][:media_type] == "0"
      @doc = Medium.new(media_params)
      if @doc.save
        flash[:success] = "Tạo mới Tài liệu #{@doc.title} thành công"
        redirect_to admin_medias_path(media_type: "0")
      else
        flash[:danger] = "Lỗi! Tạo mới Tài liệu không thành công"
        render :new
      end
    else
      @video = Medium.new(media_params)
      if @video.save
        flash[:success] = "Tạo mới video #{@video.title} thành công"
        redirect_to admin_medias_path(media_type: "1")
      else
        flash[:danger] = "Lỗi! Tạo mới video không thành công"
      end   
    end
  end

  def edit
  end

  def update
    if params[:title] || params[:video_url] || params[:description] || params[:field_id]
      @video = Medium.find_by id: params[:id]
      if @video
        if @video.update_attributes(title: params[:title], field_id: params[:field_id],
          video_url: params[:video_url], description: params[:description])
          render json: {
            status: "update-success",
            title: @video.title,
            description: @video.description,
            video_url: @video.video_url
          }
        else
          render json: {status: "update-fail"}
        end
      end
    end

    if @doc.update_attributes(media_params)
      flash[:success] = "Chỉnh sửa thàng công"
      redirect_to admin_medias_path(media_type: "0")
    end
  end

  def destroy
    if params[:media_type] == "1"
      @video = Medium.find_by id: params[:id]
      if @video
        if @video.destroy
          flash[:success] = "Xoá video #{@video.title} thành công!"
        else
          flash[:danger] = "Lỗi! Xóa video không thành công."
        end
        redirect_to admin_medias_path(media_type: "1")
      end
    else
      @doc = Medium.find_by id: params[:id]
      if @doc
        if @doc.destroy
          flash[:success] = "Xoá Tài liệu #{@doc.title} thành công!"
        else
          flash[:danger] = "Lỗi! Xóa Tài liệu không thành công."
        end
        redirect_to admin_medias_path(media_type: "0")
      end  
    end
  end

  private
  def load_doc
    @doc = Medium.find params[:id]
  end

  def media_params
    params.require(:medium).permit Medium::MEDIA_ATTRIBUTE
  end
end
