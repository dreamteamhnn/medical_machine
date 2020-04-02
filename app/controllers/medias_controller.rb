class MediasController < ApplicationController
  before_action :load_breadcrum, only: [:index, :show]

  def index
    if params[:media_type].blank? && request.path.include?("tai-lieu")
      params[:media_type] = "0"
    elsif params[:media_type].blank?
      params[:media_type] = "1"
    end

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

    @medias = if params[:custom_category_id].present?
      @field = CustomCategory.friendly.find(params[:custom_category_id])
      @medias.where("media_type = ? AND custom_category_id = ?", params[:media_type], @field.id).order(:order)
        .page(params[:page]).per(per_page_medias)
    else
      @medias.where("media_type = ?", params[:media_type]).order(:order)
        .page(params[:page]).per(per_page_medias)
    end
    @top_categories = Category.top_categories
    @brand_logos = Brand.where("image IS NOT NULL AND home_order IS NOT NULL")
                        .order(:home_order)
    set_meta_tags_with_condition
  end

  def show
    @video = Medium.find_by(id: params["id"])
    @medias = Medium.where(media_type: 1)
    @videos_related = @medias.where(custom_category_id: @video.custom_category_id)
    @top_categories = Category.top_categories
    @brand_logos = Brand.where("image IS NOT NULL AND home_order IS NOT NULL")
                        .order(:home_order)
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
                  should: [{match: {title: q}}, {match: {description: q}}, {match: {custom_category: q}}]
                }
              },
              {match: {media_type: params[:media_type].to_i}}]}}}
    }
  end

  def set_meta_tags_with_condition
    return set_meta_tags(noindex: true, follow: true) if params[:query].present?
    if params[:custom_category_id].present?
      meta_tags_hash = default_meta_tags
      media_type_name = default_meta_tags[:title]
      meta_tags_hash[:title] = "#{media_type_name} lĩnh vực #{@field.name}"
      meta_tags_hash[:description] = "#{meta_tags_hash[:title]} - #{I18n.t('site_name')} - #{Company.first.about}"
      meta_tags_hash[:keywords] = [media_type_name, @field.name, I18n.t('site_name')]
      meta_tags_hash[:twitter][:title] = meta_tags_hash[:og][:title] = meta_tags_hash[:title]
      meta_tags_hash[:twitter][:description] = meta_tags_hash[:og][:description] = meta_tags_hash[:description]
      set_meta_tags meta_tags_hash
    else
      set_meta_tags default_meta_tags
    end
  end

  def default_meta_tags
    title = params[:media_type] == "0" ? "Tài liệu" : "Video"
    description = "#{title} - #{t('site_name')} - #{Company.first.about}"
    {
      title: title,
      description: description,
      keywords: ["#{title}", I18n.t('site_name')],
      index: true,
      og: {
        title: title,
        type: "article",
        description: description,
        url: request.url,
        site_name: I18n.t('site_name')
      },
      twitter: {
        card: "summary",
        site: "@publisher_handle",
        title: title,
        description: description,
        creator: "@author_handle",
      }
    }
  end
end
