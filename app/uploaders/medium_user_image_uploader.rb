class MediumUserImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process :resize_to_fit => [200, 200]

  version :large_image do
    process resize_to_fit: [200, 200]
  end
  
  version :medium_image, :from_version => :large_image do
    process resize_to_fit: [100, 100]
  end

  version :small_image, :from_version => :medium_image do
    process resize_to_fit: [50, 50]
  end

end