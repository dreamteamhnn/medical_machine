class Medium < ApplicationRecord
  mount_uploader :url, MediaUploader

  MEDIA_ATTRIBUTE = [:title, :description, :field_id, :url, :video_url, :media_type]

  belongs_to :field

  validates :title, presence: true
  validates :description, presence: true
  validates :media_type, presence: true
  validates :field_id, presence: true

  searchkick mappings: {
    medium: {
      properties: {
        title: {type: "text", analyzer: "default", boost: 2},
        description: {type: "text", analyzer: "default"},
        field: {type: "text", analyzer: "default"},
        media_type: {type: "integer"}
      }
    }
  }

  scope :search_import,->{includes([:field])}

  def search_data
    {
      title: title,
      description: description,
      field: field.name,
      media_type: media_type
    }
  end

  def document_type
    return unless name = File.basename(url.path)
    name.split(//).last(3).join("")
  end
end
