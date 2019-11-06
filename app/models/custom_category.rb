class CustomCategory < ApplicationRecord
	has_many :media, dependent: :nullify

	CUSTOM_CATEGORY_ATTRIBUTES = %i(name custom_type)
end
