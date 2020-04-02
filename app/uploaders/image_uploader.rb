class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  #process :watermark
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url(*args)
    # For Rails 3.1+ asset pipeline compatibility:
    # ActionController::Base.helpers.asset_path("fallback/default.png")

    "/preview_no_image.jpg"
  end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :blog_thumb, if: :is_blog_img? do
    process resize_to_fit: [290, 230]
  end

  version :product_thumb, if: :is_product_img? do
    process resize_to_fit: [210, 210]
  end

  version :brand_thumb, if: :is_brand_img? do
    process resize_to_fit: [150, 75]
  end

  version :feedback_thumb, if: :is_feedback_img? do
    process resize_to_fit: [56, 56]
  end

  version :cetificate_thumb, if: :is_cetificate_img? do
    process resize_to_fit: [236, 334]
  end

  version :cetificate_active_thumb, if: :is_cetificate_img? do
    process resize_to_fit: [903, 1277]
  end

  version :slider_thumb, if: :is_slider_img? do
    process resize_to_fit: [890, 376]
  end

  version :project_thumb, if: :is_project_img? do
    process resize_to_fit: [555, 290]
  end

  def extension_whitelist
    %w(jpg jpeg png)
  end

  def watermark
    # manipulate! do |img|
    #   img.combine_options do |cmd|
    #     draw_text = Company.first.mark
    #     cmd.gravity 'south'
    #     cmd.draw "text 10,10 '#{draw_text}'"
    #     cmd.font '-*-helvetica-*-r-*-*-25-*-*-*-*-*-*-2'
    #     cmd.fill 'black'
    #   end
    #   img
    # end
    # manipulate! do |img|
    #   img.combine_options do |cmd|
    #     cmd.draw 'image Over 0,0 0,0 "public/watermark.png"'
    #   end
    #   img
    # end

    if is_product?
      watermark = Company.first.watermark.url || "public/watermark.png"
      manipulate! do |img|
        img = img.composite(MiniMagick::Image.open(watermark), "png") do |c|
          c.gravity "South"
        end
      end
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
  private
  def is_blog_img? _pic
    model.is_a? BlogImage
  end

  def is_product_img? _pic
    model.is_a? ProductImage
  end

  def is_company? _pic
    model.is_a? Company
  end

  def is_product? _pic
    model.is_a? ProductImage
  end

  def is_brand_img? _pic
    model.is_a? Brand
  end

  def is_feedback_img? _pic
    model.is_a? Feedback
  end

  def is_cetificate_img? _pic
    model.is_a? Certificate
  end

  def is_slider_img? _pic
    model.is_a? SliderCatalog
  end

  def is_project_img? _pic
    model.is_a? Project
  end
end
