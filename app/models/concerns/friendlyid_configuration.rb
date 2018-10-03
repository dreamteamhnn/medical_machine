concern :FriendlyidConfiguration do
  included do
    extend FriendlyId

    validates :name, presence: true, uniqueness: true

    friendly_id :beauty_slug, use: :slugged
  end

  private

  def beauty_slug
    name.convert_vietnamese_to_unicode
  end
end
