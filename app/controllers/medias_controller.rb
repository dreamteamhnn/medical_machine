class MediasController < ApplicationController
  before_action :load_breadcrum, only: :index

  def index
    if params[:media_type] == "0"
      per_page_medias = Settings.limit.paginate.documents
    else
      per_page_medias = Settings.limit.paginate.videos
    end

    if params[:query].present?
      @media_ids = Medium.search(search_query_body).map(&:id)
      unless @media_ids.present?
        @medias = []
        return
      end
    end

    @medias = if @media_ids.present?
      Medium.where id: @media_ids
    else
      Medium.all
    end

    @medias = if params[:field_id].present?
      @medias.where("media_type = ? AND field_id = ?", params[:media_type], params[:field_id])
        .page(params[:page]).per(per_page_medias)
    else
      @medias.where("media_type = ?", params[:media_type])
        .page(params[:page]).per(per_page_medias)
    end
  end

  private
  def load_breadcrum
    if params[:media_type] == "0"
      @breads = [{title: "Tài liệu", link: ""}]
    elsif params[:media_type] == "1"
      @breads = [{title: "Video", link: ""}]
    end
  end

  def search_query_body
    q = params[:query]
    {
      body: {
        query: {
          bool: {
            must: [
              {
                bool: {
                  should: [{match: {title: q}}, {match: {description: q}}, {match: {field: q}}]
                }
              },
              {match: {media_type: params[:media_type].to_i}}]}}}
    }
  end
end
