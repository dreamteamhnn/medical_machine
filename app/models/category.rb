class Category < ApplicationRecord
  include CategoryDecorator

  has_many :product_categories, dependent: :destroy
  has_many :products, :through => :product_categories

  has_many :parent_relations,
    foreign_key: :children_id,
    class_name: CategoryRelation.name

  has_many :children_relations,
    foreign_key: :parent_id,
    class_name: CategoryRelation.name

  has_many :parents,
    through: :parent_relations,
    class_name: Category.name

  has_many :childrens,
    through: :children_relations,
    class_name: Category.name

  CATEGORY_ATTRS = [:name, :description, :category_order, :home_block_id,
    :home_order_id]

  scope :top_categories,-> do
    where("level = ?", Settings.category.highest_level).order "category_order"
  end

  scope :by_anphabet, -> character do
    where("LEFT(name, 1) = ? AND level = ?", character.upcase,
      Settings.category.lowest_level)
  end

  def list_home_products
    return unless level == Settings.category.middle_level
    list_categories = [id]
    if c = childrens
      list_categories << c.pluck(:id)
    end
    Product.by_categories(list_categories.flatten).order(:home_order)
      .limit(Settings.limit.category_home_block)
  end

  def all_children_ids
    cat = [id]
    if childrens
      cat << childrens.pluck(:id)
      childrens.each do |c|
        if c.childrens
          cat << c.childrens.pluck(:id)
        end
      end
    end
    cat.flatten
  end

  def product_for_block_list brand_id = nil
    return [] unless level == Settings.category.middle_level
    self_products = products
    child_products = []
    child_block = []
    max = 0
    childrens.each do |child|
      ps_temp = child.products
      ps_temp = child.products.where(brand_id: brand_id) if brand_id
      ps = ps_temp.order("category_order IS NULL, category_order ASC")
      child_block << ps
      max = ps.count if ps.count > max
    end
    max.times do |i|
      child_block.each do |b|
        unless child_products.count >= Settings.limit.product_block
          child_products << b[i] if b[i]
        end
      end
    end
    child_products
  end
end
