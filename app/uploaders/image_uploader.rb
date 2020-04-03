class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  #process :watermark
  # storage :fog

  # process convert_to_webp: [{ quality: 80, method: 5 }]

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
  version :blog_webp, if: :is_blog_img? do
    process resize_to_fit: [290, 230]
    process convert_to_webp: [{ quality: 80, method: 5 }]
  end

  version :product_webp, if: :is_product_img? do
    process resize_to_fit: [210, 210]
    process convert_to_webp: [{ quality: 80, method: 5 }]
  end

  version :brand_webp, if: :is_brand_img? do
    process resize_to_fit: [150, 75]
    process convert_to_webp: [{ quality: 80, method: 5 }]
  end

  version :feedback_webp, if: :is_feedback_img? do
    process resize_to_fit: [56, 56]
    process convert_to_webp: [{ quality: 80, method: 5 }]
  end

  version :cetificate_webp, if: :is_cetificate_img? do
    process resize_to_fit: [236, 334]
    process convert_to_webp: [{ quality: 80, method: 5 }]
  end

  version :cetificate_active_webp, if: :is_cetificate_img? do
    process resize_to_fit: [903, 1277]
    process convert_to_webp: [{ quality: 80, method: 5 }]
  end

  version :slider_webp, if: :is_slider_img? do
    process resize_to_fit: [890, 376]
    process convert_to_webp: [{ quality: 80, method: 5 }]
  end

  version :project_webp, if: :is_project_img? do
    process resize_to_fit: [555, 290]
    process convert_to_webp: [{ quality: 80, method: 5 }]
  end

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
    if is_product?
      watermark = Company.first.watermark.url || "public/watermark.png"
      manipulate! do |img|
        img = img.composite(MiniMagick::Image.open(watermark), "png") do |c|
          c.gravity "South"
        end
      end
    end
  end

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

  def convert_to_webp(options = {})
    # Build path for new file
    webp_path = "#{path}.webp"

    # Encode (convert) image to webp format with passed options
    WebP.encode(path, webp_path, options)

    # HACK: Changing of this two instance variables is the only way 
    #   I found to make CarrierWave save new file that was created 
    #   by encoding original image.
    @filename = webp_path.split('/').pop

    @file = CarrierWave::SanitizedFile.new(
      tempfile: webp_path,
      filename: webp_path,
      content_type: 'image/webp'
    )
  end
end
