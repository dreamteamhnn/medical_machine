class PagesController < ApplicationController
  def home
    @top_categories = Category.top_categories.limit(Settings.list_categories)
    @blogs = Blog.new_articles_for_home
    @sliders = SliderCatalog.where(image_type: "slider")
    # @catalogs = SliderCatalog.where(image_type: "catalog").limit Settings.limit.catalog
    # @product_labels = Label.all.order(:block_order)
    #   .includes(products: [:categories]).limit Settings.limit.label_block
    @brand_logos = Brand.where("image IS NOT NULL AND home_order IS NOT NULL").order(:home_order)
    get_home_category
    @company = Company.first
    set_meta_tags meta_tags_hash
    @feedbacks = Feedback.all
    projects = Project.all.order(order: :desc).limit(5)
    if projects.present?
      @first_project = projects.first
      @other_projects = projects.where.not(id: @first_project.id)
    end
    @certificates_mobile = Certificate.all.order(order: :desc)
    @certificates = @certificates_mobile.in_groups_of(3)
  end

  def get_home_category
    @home_blocks = [home_block_1, home_block_2]
  end

  private
  (1..2).each do |i|
    define_method"home_block_#{i}" do
      categories = Category.where(home_block_id: i).order(:home_order_id)
        .limit(Settings.limit.home_block_category)
      home_block_arr = []
      categories.each do |category|
        products = category.list_home_products
        if products.size > 0
          home_block_arr << {title: category.name, id: category.id,
            products: products}
        end
      end
      home_block_arr
    end
  end

  def meta_tags_hash
    description = "#{@company.logo_alt}. #{@company.about}"
    description = "Stech Sài Gòn: Chuyên cung cấp Thiết bị khoa học, Thiết bị thí nghiệm, Thiết bị y tế, ... Uy tín và chuyên nghiệp. Với các sản phẩm được nhập khẩu chính hãng, hàng có sẵn tại Hà Nội và Hồ Chí Minh. Stech cam kết: Giao hàng nhanh nhất - Giá rẻ nhất - Bảo hành 12 tháng!"
    {
      title: "Stech Sài Gòn - Cung cấp Thiết bị - Vật tư khoa học Uy tín!",
      description: description,
      keywords: ["Stech Sài Gòn"] + Category.where(level: 1).pluck(:name), #, "thiết bị thí nghiệm", "thiết bị y tế", "thiết bị khoa học kỹ thuật"
      index: true,
      og: {
        title: I18n.t("site_name"),
        type: "article",
        description: description,
        url: request.url,
        site_name: I18n.t('site_name')
      },
      twitter: {
        card: "summary",
        site: "@publisher_handle",
        title: I18n.t("site_name"),
        description: description,
        creator: "@author_handle",
      }
    }
  end

  def update_cloudinary_image_url
    Product.all.each do |p|
      if p.img_1.present? && p.img_1.include?("/upload/") && !p.img_1.include?("f_auto")
        p.img_1["/upload/q_auto/"] = "/upload/q_auto/f_auto/"
      end

      if p.img_2.present? && p.img_2.include?("/upload/") && !p.img_2.include?("f_auto")
        p.img_2["/upload/q_auto/"] = "/upload/q_auto/f_auto/"
      end
      p.save
    end
  end
end
