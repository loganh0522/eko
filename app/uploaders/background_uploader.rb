class BackgroundUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  process :resize_to_fit => [1250, 800]

  version :large do 
    process :resize_to_fit => [1250, 800]
  end

  version :medium do
    resize_to_fill(200, 200)
  end
end