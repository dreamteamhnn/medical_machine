class Blog < ApplicationRecord
  include BlogDecorator
  extend FriendlyId

  validates :title, presence: true, uniqueness: true

  friendly_id :beauty_slug, use: :slugged

  paginates_per Settings.limit.paginate.admin_blog

  # belongs_to :template
  has_many :blog_images, dependent: :destroy
  has_many :feature_images, ->{where(is_feature: true)},
    class_name: BlogImage.name

  has_many :blog_category_relations, dependent: :destroy
  has_many :blog_categories, through: :blog_category_relations

  has_many :blog_tag_relations, dependent: :destroy
  has_many :tags, through: :blog_tag_relations

  accepts_nested_attributes_for :blog_images, allow_destroy: true

  scope :new_articles_for_home, -> do
    where(is_important: true)
      .order("created_at DESC").limit(Settings.limit.blog_home_page)
      .includes :blog_images
  end

  scope :by_category, -> category_id do
    joins(:blog_category_relations)
    .where("blog_category_relations.blog_category_id = ?", category_id)
  end

  scope :by_tag, -> tag_id do
    joins(:blog_tag_relations)
    .where("blog_tag_relations.tag_id = ?", tag_id)
  end

  scope :by_category_and_tag, -> category_id, tag_id do
    joins(:blog_category_relations)
    .where("blog_category_relations.blog_category_id = ?", category_id)
    joins(:blog_tag_relations)
    .where("blog_tag_relations.tag_id = ?", tag_id)
  end

  scope :by_time, -> time do
    where("MONTH(created_at) = ? AND YEAR(created_at) = ?", time[0], time[1])
  end

  def time_param
    m = created_at.month
    y = created_at.year
    {value: "#{m}_#{y}", title: "Tháng #{m}/#{y}"}
  end

  private

  def beauty_slug
    title.convert_vietnamese_to_unicode
  end
end
