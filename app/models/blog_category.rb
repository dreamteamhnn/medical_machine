class BlogCategory < ApplicationRecord
  include BlogCategoryDecorator

  has_many :blog_category_relations, dependent: :destroy
  has_many :blogs, through: :blog_category_relations

  validates :name, presence: true, uniqueness: true

  extend FriendlyId

  friendly_id :beauty_slug, use: :slugged

  private

  def beauty_slug
    name.convert_vietnamese_to_unicode
  end

  class << self
    def category_list_with_blog_count
      query = %{
        select c.id as c_id, c.name as c_name, c.order as c_order, count(r.id) as blog_num
        from blog_categories c
        left join blog_category_relations r
          on c.id = r.blog_category_id
        group by c.id
        order by blog_num DESC
      }
      find_by_sql query
    end
  end
end
