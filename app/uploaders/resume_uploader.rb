class ResumeUploader < CarrierWave::Uploader::Base
  

  def store_dir
    "public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(pdf doc docx)
  end
end