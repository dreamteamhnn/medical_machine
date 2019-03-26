module BlogDecorator
  extend ActiveSupport::Concern
  include SeoSupport

  def feature_image
    @feature_image ||= blog_images.find(&:is_feature)&.primary_content
  end

  BlogImage::SELECTED_ATTRS.push(:thumb_url).each do |attr|
    define_method("feature_image_#{attr}"){feature_image[attr]}
  end

  def to_meta_tags
    simple_title = simple_text(title, Settings.seo.max_length.title)
    description = simple_text(content, Settings.seo.max_length.description)
    url = Rails.application.routes.url_helpers.blog_detail_url(self, host: Settings.current_host)
    image = feature_image ? feature_image[:thumb_url] : nil
    {
      title: simple_title,
      description: description,
      keywords: blog_categories.pluck(:name),
      image_src: image,
      index: true,
      og: {
        title: simple_title,
        type: "article",
        description: description,
        url: url,
        image: image,
        site_name: I18n.t('site_name')
      },
      twitter: {
        card: "summary",
        site: "@publisher_handle",
        title: simple_title,
        description: description,
        creator: "@author_handle",
        image: image
      }
    }
  end
end
