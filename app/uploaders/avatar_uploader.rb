class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  resize_to_limit(300, 300)

  version :large_image do
    process :crop
    resize_to_fit(150, 150)
  end
  
  version :medium_image do
    process :crop
    resize_to_fit(100, 100)
  end

  version :small_image do
    process :crop
    resize_to_fill(50, 50)
  end

  version :thumb do
    process :crop
    resize_to_fill(33, 33)
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def crop
    resize_to_limit(300, 300)
    if model.crop_x.present?
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i 
        w = model.crop_w.to_i
        h = model.crop_h.to_i 
        img.crop!(x, y, w, h)
      end
    end
  end

  protected
  
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end