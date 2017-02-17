class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process resize_to_fill: [300, 300]

  version :large_image do
    process :crop
    resize_to_fill(150, 150)
  end
  
  version :medium_image do
    process :crop
    resize_to_fill(100, 100)
  end

  version :small_image do
    process :crop
    resize_to_fill(50, 50)
  end

  def crop
    if model.crop_x.present?
      resize_to_fill(300, 300)
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i 
        w = model.crop_w.to_i
        h = model.crop_h.to_i 
        img.crop("#{w}x#{h}+#{x}+#{y}")
      end
    end
  end

end