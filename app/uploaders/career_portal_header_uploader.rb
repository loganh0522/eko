class CareerPortalHeaderUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  process :resize_to_fit => [1280, 400]
end