class BlogCategory < ApplicationRecord
  has_many :blog_category_relations, dependent: :destroy
  has_many :blogs, through: :blog_category_relations

  class << self
    def category_list_with_blog_count
      query = %{
        select c.id as c_id, c.name as c_name, count(r.id) as blog_num
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
