class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  version :large_image, :if => :image?  do
    resize_to_fit(500, 500)
  end
  
  version :medium_image, :if => :image?  do
    resize_to_fit(300, 300)
  end

  version :small_image, :if => :image?  do
    resize_to_fit(300, 200)
  end

  version :xs_image, :if => :image?  do
    resize_to_fit(100, 100)
  end

  version :thumb, :if => :image? do 
    resize_to_fit(50, 50)
  end

  version :pdf_thumb, :if => :pdf? do
    process :thumbnail_pdf
    process :set_content_type_png

    def full_filename (for_file = model.artifact.file)
      super.chomp(File.extname(super)) + '.png'
    end
  end

  def thumbnail_pdf
    manipulate! do |img|
      img.format("png", 1)
      img.resize("150x150")
      img = yield(img) if block_given?
      img
    end
  end

  protected

  def image?(new_file)
    new_file.content_type.start_with? 'image'
  end
end