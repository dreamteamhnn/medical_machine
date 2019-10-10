class Admin::MultipleCategoriesController < Admin::BaseController
	before_action :load_categories, only: :edit

	def edit
		@selected_products = Category.find_by(id: params[:category_id]).try(&:products).try(:uniq) || []
		@unselected_products = Product.where.not(id: @selected_products.map(&:id)).try(:uniq) || []
	end

	def update
		category_id = params[:category_id].try(&:to_i)
		if category_id > 0
			if params[:commit] == 'left-to-right'
				removeIds = params[:selectedIds].split(",").map(&:to_i)
				ProductCategory.where(category_id: category_id, product_id: removeIds).destroy_all
			elsif params[:commit] == 'right-to-left'
				addIds = params[:unselectedIds].split(",").map(&:to_i)
				addIds.each do |id|
					exist_record = ProductCategory.find_by(category_id: category_id, product_id: id)
					ProductCategory.create(category_id: category_id, product_id: id) unless exist_record.present?
				end
			elsif params[:commit] == 'save-change' && params[:order_id].present?
				order_ids = JSON.parse(params[:order_id])
				order_ids.each do |obj|
					exist_record = ProductCategory.find_by(category_id: category_id, product_id: obj["id"])
					order_value = obj["order"].try(:to_i) != 0 ? obj["order"].try(:to_i) : nil
					exist_record.update_attributes(list_order: order_value) if exist_record.present?
				end
			end
			flash[:notice] = "Update thành công"
		end
		redirect_to edit_admin_multiple_category_path(category_id: category_id)
	end

	def products_by_category
		selected_products = Category.find_by(id: params[:category_id]).try(&:products).uniq.sort.map do |product|
			['', product.id.to_s, img(product.img_1), product.name, product.model]
		end
		unselected_products = Product.joins(:product_categories).where.not("product_categories.category_id = ?",  params[:category_id]).uniq.sort.map do |product|
			['', product.id.to_s, img(product.img_1), product.name, product.model]
		end
		render json: {selected: selected_products, unselected: unselected_products}
	end

	private

	def load_categories
		@multiple_category = Category.find_by id: params[:id]
		@highest_group = Category.where(level: Settings.category.highest_level).group_by(&:childrens)
		@middle_group = Category.where(level: Settings.category.middle_level).group_by(&:childrens)
		highest_group = Category.where(level: Settings.category.highest_level)
		@all_categories = highest_group.map do |parent|
			childrens = parent.childrens.map do |children|
				[children, children.childrens]
			end
			[parent, childrens]
		end
	end

	def img url
		"<img src='#{url}' style='height:30px; width:30px'>"
	end
end