concern :FriendlyidConfiguration do
  included do
    extend FriendlyId

    validates :name, presence: true
    # validates :name, presence: true, uniqueness: true

    friendly_id :beauty_slug, use: :slugged

    before_update do
      if name_changed?
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
    [name.convert_vietnamese_to_unicode, id]
      .compact.join "-#{self.class.name.downcase.slice(0)}"
  end
end
