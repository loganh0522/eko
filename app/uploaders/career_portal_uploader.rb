class CareerPortalUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  process :resize_to_fit => [200, 50]
end