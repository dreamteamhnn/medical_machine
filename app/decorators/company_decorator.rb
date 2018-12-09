module CompanyDecorator
  extend ActiveSupport::Concern
  include SeoSupport

  def to_meta_tags
    title = "Địa chỉ liên hệ"
    description = about ? simple_text(about, Settings.seo.max_length.description) : "#{title} - #{I18n.t('site_name')}"
    url = Rails.application.routes.url_helpers.friendly_contact_url(self, host: Settings.current_host)
    {
      title: title,
      description: description,
      keywords: [title, I18n.t('site_name')],
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
