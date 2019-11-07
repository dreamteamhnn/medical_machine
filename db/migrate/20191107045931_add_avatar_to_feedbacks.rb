class AddAvatarToFeedbacks < ActiveRecord::Migration[5.1]
  def change
    add_column :feedbacks, :avatar, :string
  end
end
