class CareerPortalUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :resize_to_fill => [200, 100]
end