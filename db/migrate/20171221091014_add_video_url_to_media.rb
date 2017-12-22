class AddVideoUrlToMedia < ActiveRecord::Migration[5.1]
  def change
    add_column :media, :video_url, :string
  end
end
