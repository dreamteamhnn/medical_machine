module CategoryDecorator
  extend ActiveSupport::Concern
  include SeoSupport

  def feature_image
    return unless level == Settings.category.highest_level
    "category/#{images_of_top_category[category_order - 1]}"
  end

  def feature_image_2
    return unless level == Settings.category.highest_level
    "category/#{images_of_top_category[category_order + 5]}"
  end

  def to_meta_tags
    title = name.truncate(Settings.seo.max_length.title, omission: "", separator: " ")
    description = description ? simple_text(description, Settings.seo.max_length.description) : "Danh sách sản phẩm của danh mục #{name} - #{I18n.t('site_name')}"
    url = Rails.application.routes.url_helpers.product_categories_url(self, host: Settings.current_host)
    {
      title: title,
      description: description,
      keywords: [name, I18n.t('site_name')],
      index: true,
      og: {
        title: title,
        type: "article",
        description: description,
        url: url,
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

  private
  def images_of_top_category
    @images_of_top_category ||= Dir.glob("app/assets/images/category/*")
      .map do |img|
      img.split("/").last
    end.sort
  end
end
