class CareerPortalUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  process :resize_to_fill => [150, 25]
end