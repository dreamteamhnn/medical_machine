class Medium < ApplicationRecord
  mount_uploader :url, MediaUploader

  MEDIA_ATTRIBUTE = [:title, :description, :custom_category_id, :url, :video_url, :media_type]

  belongs_to :custom_category

  validates :title, presence: true
  validates :description, presence: true
  validates :media_type, presence: true
  validates :custom_category_id, presence: true

  searchkick mappings: {
    medium: {
      properties: {
        title: {type: "text", analyzer: "default", boost: 2},
        description: {type: "text", analyzer: "default"},
        custom_category: {type: "text", analyzer: "default"},
        media_type: {type: "integer"}
      }
    }
  }

  scope :search_import,->{includes([:custom_category])}

  def search_data
    {
      title: title,
      description: description,
      custom_category: custom_category.name,
      media_type: media_type
    }
  end

  def document_type
    return unless name = File.basename(url.path)
    name.split(//).last(3).join("")
  end
end
