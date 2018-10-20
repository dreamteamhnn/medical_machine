class Admin::HomeCategoriesController < Admin::BaseController
	before_action :load_categories, only: [:edit, :update]
	before_action :reset_home, only: :update

	def edit
		
	end

	def update
		home_top = params[:home_top].split(',')
		home_bottom = params[:home_bottom].split(',')
		home_top.each_with_index do |id, idx|
			if category = Category.find_by(id: id)
				category.update_attributes(home_block_id: Settings.category.home_block_1, home_order_id: idx + 1)
			end
		end
		home_bottom.each_with_index do |id, idx|
			if category = Category.find_by(id: id)
				category.update_attributes(home_block_id: Settings.category.home_block_2, home_order_id: idx + 1)
			end
		end
		flash[:success] = "Thay đổi thành công"
		redirect_to edit_admin_home_category_path(Category.first)
	end

	private

	def load_categories
		@home_category = Category.find_by(id: params[:id])
		@all_categories = Category.where(level: Settings.category.highest_level).group_by(&:childrens)
		@home_top = Category.where(home_block_id: Settings.category.home_block_1)
		@home_bottom = Category.where(home_block_id: Settings.category.home_block_2)
	end

	def reset_home
		Category.all.update_all(home_block_id: nil, home_order_id: nil)
	end
end
