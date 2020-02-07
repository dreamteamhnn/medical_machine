class Blog < ApplicationRecord
  extend FriendlyId
  include BlogDecorator

  friendly_id :beauty_slug, use: :slugged

  before_save do
    if title_changed?
      self.slug = beauty_slug
    end
  end

  after_create do
    self.slug = nil
    self.save
  end

  validates :title, presence: true, uniqueness: true

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

  scope :take_ordered_list, ->{order('IF(`order` IS NULL, 99999, `order`) ASC, created_at DESC')}

  scope :new_articles_for_home, -> do
    where(is_important: true)
      .order("RAND()")
      .take_ordered_list.limit(Settings.limit.blog_home_page)
      .includes :blog_images
  end

  scope :new_articles_for_related, -> do
    where(is_important: true)
      .take_ordered_list.limit(Settings.limit.blog_related)
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

  scope :by_keyword, -> keyword do
    where("title LIKE ? OR content LIKE ?", "%#{keyword}%", "%#{keyword}%")
  end

  def time_param
    m = created_at.month
    y = created_at.year
    {value: "#{m}_#{y}", title: "Tháng #{m}/#{y}"}
  end

  class << self
    def bulk_delete_execute ids
      self.transaction do
        ids.each do |blog_id|
          Blog.find(blog_id).destroy
        end
      end
    result = {ok: true}
    rescue ActiveRecord::RecordNotFound => e
      result = {ok: false, error_msg: e.message}
    end
  end

  private

  def beauty_slug
    title.convert_vietnamese_to_unicode
  end
end
