class MediaPhotosUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  process resize_to_fill: [400, 400]
  
  # version :large_image do
  #   resize_to_fill(400, 400)
  # end
  
  # version :medium_image do
  #   resize_to_fill(300, 300)
  # end

  # version :small_image do
  #   resize_to_fill(200, 200)
  # end
end