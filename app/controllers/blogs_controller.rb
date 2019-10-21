class BlogsController < ApplicationController
  before_action :load_blog, only: :show
  before_action :load_blogs, only: :index
  before_action :load_left_menu, only: [:show, :index]

  def index
    @top_categories = Category.top_categories
    @brand_logos = Brand.where("image IS NOT NULL AND home_order IS NOT NULL")
                        .order(:home_order)
  end

  def show
    set_meta_tags @blog
  end

  private
  def load_blogs
    if params[:blog_category_id]
      @category = BlogCategory.friendly.find params[:blog_category_id]
      @blogs = Blog.by_category(@category.id)
      set_meta_tags @category
    elsif params[:tag_id]
      @blogs = Blog.by_tag(params[:tag_id].to_i)
    elsif params[:time]
      @blogs = Blog.by_time(params[:time].split("_").map(&:to_i))
    else
      @blogs = Blog.all
      set_meta_tags meta_tags_hash
    end
    @blogs = @blogs.distinct.take_ordered_list.page(params[:page]).per(Settings.limit.paginate.blogs)
    @breads = [{title: "Tin Tức", link: ""}]
  end

  def load_left_menu
    @blog_categories = BlogCategory.all
    @tags = Tag.all
    @times = Blog.all.map {|blog| blog.time_param}.uniq
  end

  def load_blog
    @blog = Blog.friendly.find params[:id]
    @next = next_blog
    @prev = prev_blog
    @blog_relate_1 = Blog.find_by id: @blog.relation_blog_id_1
    @blog_relate_2 = Blog.find_by id: @blog.relation_blog_id_2
    @breads = [{title: "Blog", link: blogs_path()}]
    @breads << {title: @blog.title, link: ""}
  end

  def next_blog
    Blog.where("id > ?", params[:id]).first
  end

  def prev_blog
    Blog.where("id < ?", params[:id]).last
  end

  def meta_tags_hash
    simple_title = 'Tin tức'
    description = simple_title
    url = request.url
    {
      title: simple_title,
      description: description,
      keywords: ['Tin tức', t("site_name")],
      index: true,
      og: {
        title: simple_title,
        type: "article",
        description: description,
        url: url,
        site_name: I18n.t('site_name')
      },
      twitter: {
        card: "summary",
        site: "@publisher_handle",
        title: simple_title,
        description: description,
        creator: "@author_handle"
      }
    }
  end
end
