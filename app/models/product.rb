class Product < ApplicationRecord
  include FriendlyidConfiguration
  include ProductDecorator

  searchkick mappings: {
    product: {
      properties: {
        title: {type: "text", analyzer: "default", boost: 2},
        category: {type: "text", analyzer: "default"},
        brand: {type: "text", analyzer: "default"},
        field: {type: "text", analyzer: "default"},
      }
    }
  }, settings: {
    number_of_shards: 1,
    number_of_replicas: 1
  }

  scope :search_import,->{includes([:categories, :brand, :fields])}
  scope :by_ids,->(ids){where id: ids}

  def search_data
    {
      title: name,
      category: categories.pluck(:name).join(" "),
      brand: brand.try(:name).to_s,
      field: fields.pluck(:name).join(" ")
    }
  end

  PRODUCT_ATTRIBUTES = %i(name static_url meta_title model price discount_price description short_description 
                          parameter brand_id is_parameter_table img_1 img_2 img_1_title img_1_desc img_1_caption img_1_alt
                          img_2_title img_2_desc img_2_caption img_2_alt no_order)

  PRODUCT_IMAGE_ATTRIBUTES = [:id, :title, :url, :desc, :caption, :alt, :_destroy]
  PRODUCT_CATEGORY_ATTRIBUTES = [:id, :category_id, :home_order, :list_order, :_destroy]
  PRODUCT_FIELD_ATTRIBUTES = [:id, :field_id, :menu_order, :list_order, :_destroy]
  PRODUCT_MEDIA_ATTRIBUTES = [:id, :medium_id, :_destroy]

  validates :name, presence: true, length: {maximum: 500}
  validates :model, presence: true, length: {maximum: 100}
  validates :description, presence: true
  validates :short_description, presence: true
  validates :parameter, presence: true

  belongs_to :brand, optional: true

  # has_many :product_images, dependent: :destroy
  # accepts_nested_attributes_for :product_images

  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  accepts_nested_attributes_for :product_categories

  has_many :product_fields, dependent: :destroy
  has_many :fields, through: :product_fields
  accepts_nested_attributes_for :product_fields

  has_many :product_media_relations, dependent: :destroy
  has_many :mediums, through: :product_media_relations
  accepts_nested_attributes_for :product_media_relations
  has_many :customer_orders, dependent: :destroy

  scope :sort_from_price, -> min_price do
    where "price >= ?", min_price
  end

  scope :sort_to_price, -> max_price do
    where "price <= ?", max_price
  end

  scope :sort_in_range, -> range do
    where "price BETWEEN ? AND ?", range[0], range[1]
  end

  scope :by_categories, -> category_ids do
    joins(:product_categories)
      .where("product_categories.category_id IN (?)",
        category_ids)
  end

  SORT_FIELDS = {
    name: "name",
    date: "date",
    price: "price",
    price_desc: "price_desc"
  }

  def price_currency
    return nil unless price
    helper.number_to_currency(price*1000, unit: "", delimiter: ".", precision: 0)
  end

  def discount_price_currency
    return nil unless (discount_price.present? && price.present? && discount_price < price)
    helper.number_to_currency(discount_price*1000, unit: "", delimiter: ".", precision: 0)
  end

  def name_multi
    length = name.length
    return name unless length < 44
    space = " "
    name + space*(44-length)
  end

  def param_table
    return parameter unless is_parameter_table
    table = []
    parameter.split(",").each do |p|
      table << {title: p.split(":")[0], value: p.split(":")[1]}
    end
    table
  end

  def category_name
    category_name = []
    categories.each do |category|
      category_name << category.name
    end
    category_name.join(", ")
  end

  def field_name
    field_name = []
    fields.each do |field|
      field_name << field.name
    end
    field_name.join(", ")
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = accessible_attributes
    if spreadsheet.row(1)[0] == "Id"
      header = ([:id] + accessible_attributes).flatten
    end
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      product = find_by_id(row[:id]) || new
      if !row[:id] || (row[:id] && product)
        product.attributes = row.to_hash.slice(*accessible_attributes)
        product.save!(validate: false)
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.xlsx' then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.accessible_attributes
   [:name, :model, :price, :discount_price, :description, :short_description, :parameter]
  end
end
