concern :FriendlyidConfiguration do
  included do
    extend FriendlyId

    validates :name, presence: true
    # validates :name, presence: true, uniqueness: true

    friendly_id :beauty_slug, use: :slugged

    before_save do
      if name_changed? || (self.class.name == "Product" && static_url_changed?)
        self.slug = beauty_slug
      end
    end

    after_create do
      self.slug = nil
      self.save
    end
  end

  private

  def beauty_slug
    if self.class.name == "Product" && static_url.present?
      static_url
    else
      [name.convert_vietnamese_to_unicode, id]
        .compact.join "-#{self.class.name.downcase.slice(0)}"
    end
  end
end
