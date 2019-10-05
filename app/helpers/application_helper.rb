module ApplicationHelper
  # def resource_name
  #   :admin
  # end

  # def resource
  #   @resource ||= Admin.new
  # end

  # def devise_mapping
  #   @devise_mapping ||= Devise.mappings[:admin]
  # end

  def get_image image
    image.present? ? image.image_url.url : Settings.default_image
  end
end
