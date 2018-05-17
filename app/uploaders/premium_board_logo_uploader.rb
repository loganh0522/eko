class PremiumBoardLogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  version :large_image do
    process :resize_to_fit => [400, 300]
  end
  
  version :medium_image do
    process :resize_to_fit => [300, 200]
  end

  version :small_image do
    process :resize_to_fit => [200, 100]
  end
end