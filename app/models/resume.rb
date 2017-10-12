class Resume < ActiveRecord::Base
  belongs_to :candidate

  mount_uploader :name, ResumeUploader


  def set_filetype
    File.basename(self.name.path).split('.')[]
  end
end