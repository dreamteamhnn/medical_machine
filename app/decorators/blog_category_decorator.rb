module BlogCategoryDecorator
  extend ActiveSupport::Concern
  include SeoSupport

  def to_meta_tags
    simple_title = simple_text(name, Settings.seo.max_length.title)
    description = simple_title
    url = Rails.application.routes.url_helpers.blog_list_category_url(self, host: Settings.current_host)
    {
      title: simple_title,
      description: description,
      keywords: ['Tin tức', title],
      index: true,
      og: {
        title: simple_title,
        type: "article",
        description: description,
        url: url,
        site_name: I18n.t('site_name')
      },
      twitter: {
        card: "summary",
        site: "@publisher_handle",
        title: simple_title,
        description: description,
        creator: "@author_handle"
      }
    }
  end
end
