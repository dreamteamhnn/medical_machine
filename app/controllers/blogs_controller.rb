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
    @top_categories = Category.top_categories
    @brand_logos = Brand.where("image IS NOT NULL AND home_order IS NOT NULL")
                        .order(:home_order)
  end

  private
  def load_blogs
    if params[:blog_category_id]
      @category = BlogCategory.friendly.find params[:blog_category_id]
      @blogs = Blog.by_category(@category.id).limit(4)
      @other_blogs = Blog.all.where.not(id: @blogs.map(&:id)).page(params[:page]).per(Settings.limit.paginate.blogs)
      set_meta_tags @category
    elsif params[:tag_id]
      @blogs = Blog.by_tag(params[:tag_id].to_i)
    elsif params[:time]
      @blogs = Blog.by_time(params[:time].split("_").map(&:to_i))
    else
      @blogs = Blog.where(is_important: true).order(order: :desc).limit(4)
      @typical_blogs = Blog.by_category(BlogCategory.friendly.find('hang-san-xuat-uy-tin')).where.not(id: @blogs&.map(&:id)).order("RAND()").limit(8)
      
      smart_except = []
      smart_except += @blogs&.map(&:id) if @blogs&.map(&:id).present?
      smart_except += @typical_blogs&.map(&:id) if @typical_blogs&.map(&:id).present?
      @smart_blogs = Blog.by_category(BlogCategory.friendly.find('kinh-nghiem-lua-chon-san-pham')).where.not(id: smart_except).order("RAND()").limit(8)
      
      tech_except = smart_except
      tech_except += @smart_blogs&.map(&:id) if @smart_blogs&.map(&:id).present?
      @tech_blogs = Blog.by_category(BlogCategory.friendly.find('tin-tuc-khoa-hoc-cong-nghe')).where.not(id: tech_except).order("RAND()").limit(4)

      sale_except = tech_except
      sale_except += @tech_blogs&.map(&:id) if @tech_blogs&.map(&:id).present?
      @sale_blogs = Blog.where.not(id: sale_except).order("RAND()").limit(8)
      set_meta_tags meta_tags_hash
    end
    # @blogs = @blogs.distinct.take_ordered_list.page(params[:page]).per(Settings.limit.paginate.blogs)
    @breads = [{title: "Tin công nghệ", link: ""}]
  end

  def load_left_menu
    @blog_categories = BlogCategory.all.order(:order)
    @tags = Tag.all
    @times = Blog.all.map {|blog| blog.time_param}.uniq
    max_aside = 4
    if params[:blog_category_id].present?
      blog_size = @other_blogs.count
      if @blogs.count == 0
        max_aside = 0
      elsif blog_size > 16
        max_aside = 3
      elsif blog_size > 4
        max_aside = 2
      elsif blog_size > 0
        max_aside = 1
      else
        max_aside = 0
      end
    elsif Blog.count >= 8
      max_aside = 4
      max_aside = 3 unless @tech_blogs.present?
    end
    @aside_products = Product.order("RAND()").limit(max_aside)
  end

  def load_blog
    @blog = Blog.friendly.find params[:id]
    @more_blogs = Blog.by_category(@blog.blog_categories.first.id).where.not(id: @blog.id).order("RAND()").limit(5)
    @suggestion_blogs = Blog.where.not(id: [@blog.id] + @more_blogs.map(&:id)).order("RAND()").limit(8)
    # @next = next_blog
    # @prev = prev_blog
    # @blog_relate_1 = Blog.find_by id: @blog.relation_blog_id_1
    # @blog_relate_2 = Blog.find_by id: @blog.relation_blog_id_2
    @breads = [{title: "Tin tức", link: blogs_path()}]
    @breads << {title: @blog.title, link: ""}
  end

  def next_blog
    Blog.where("id > ?", params[:id]).first
  end

  def prev_blog
    Blog.where("id < ?", params[:id]).last
  end

  def meta_tags_hash
    simple_title = 'Tin công nghệ'
    description = simple_title
    url = request.url
    {
      title: simple_title,
      description: description,
      keywords: ['Tin công nghệ', t("site_name")],
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
