class TeamMembersUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  process resize_to_fit: [400, 400]
  
  version :large_image do
    resize_to_fit(400, 400)
  end
  
  version :medium_image do
    resize_to_fit(300, 300)
  end

  version :small_image do
    resize_to_fit(200, 200)
  end

  version :xs_image do
    resize_to_fit(100, 100)
  end
end