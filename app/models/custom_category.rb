class CustomCategory < ApplicationRecord
	extend FriendlyId

  	friendly_id :beauty_slug, use: :slugged

	has_many :media, dependent: :nullify

	CUSTOM_CATEGORY_ATTRIBUTES = %i(name custom_type order)

	private

	def beauty_slug
		name.convert_vietnamese_to_unicode
	end
end
