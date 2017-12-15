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

  

  protected

  def image?(new_file)
    new_file.content_type.start_with? 'image'
  end
end