class LogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :resize_to_fit => [200, 200]

  version :large_logo do
    process :resize_to_fit => [200, 50]
  end

  version :medium_logo do 
    process :resize_to_fit => [100, 100]
  end

  version :small_logo do 
    process :resize_to_fit => [50, 100]
  end

  version :thumb_nail do
    process :resize_to_fit => [50, 50]
  end

end