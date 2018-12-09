module FieldDecorator
  extend ActiveSupport::Concern
  include SeoSupport

  def to_meta_tags
    title = "Danh sách sản phẩm thuộc lĩnh vực #{name}"
    description = description ? simple_text(description, Settings.seo.max_length.description) : "#{title} - #{I18n.t('site_name')}"
    url = Rails.application.routes.url_helpers.product_field_url(self, host: Settings.current_host)
    {
      title: title,
      description: description,
      keywords: ["#{name}", I18n.t('site_name')],
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
end
