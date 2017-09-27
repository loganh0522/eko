class ResumeUploader < CarrierWave::Uploader::Base

  def extension_white_list
    %w(pdf doc docx)
  end
end