class BlogsController < ApplicationController
  before_action :load_blog, only: :show
  before_action :load_blogs, only: :index
  before_action :load_left_menu, only: [:show, :index]

  def index;end

  def show
  end

  private
  def load_blogs
    if params[:blog_category_id]
      @blogs = Blog.by_category(params[:blog_category_id].to_i)
    elsif params[:tag_id]
      @blogs = Blog.by_tag(params[:tag_id].to_i)
    elsif params[:time]
      @blogs = Blog.by_time(params[:time].split("_").map(&:to_i))
    else
      @blogs = Blog.all
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
end
