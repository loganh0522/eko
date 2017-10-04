class CareerPortalUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  process :resize_to_fill => [200, 100]
end