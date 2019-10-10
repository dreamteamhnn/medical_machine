module ProductDecorator
  extend ActiveSupport::Concern
  include SeoSupport

  def showed_price
    return "LIÊN HỆ" unless discount_price.present? && price.present?
    "#{discount_price_currency || price_currency}VNĐ"
  end

  def to_meta_tags
    title = simple_text(name, Settings.seo.max_length.title)
    description = simple_text(short_description, Settings.seo.max_length.description)
    url = Rails.application.routes.url_helpers.friendly_product_url(self, host: Settings.current_host)
    # image = product_images.first.url_url(:product_thumb) //toanlh
    {
      title: title,
      description: description,
      keywords: categories.pluck(:name).push(I18n.t('site_name')),
      image_src: img_1,
      index: true,
      og: {
        title: title,
        type: "article",
        description: description,
        url: url,
        image: img_1,
        site_name: I18n.t('site_name')
      },
      twitter: {
        card: "product",
        site: "@publisher_handle",
        title: title,
        description: description,
        creator: "@author_handle",
        image: img_1
      }
    }
  end
end
