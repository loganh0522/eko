class Resume < ActiveRecord::Base
  belongs_to :candidate

  mount_uploader :name, ResumeUploader

  validates_presence_of :name

  def set_filetype
    File.basename(self.name.path).split('.')[]
  end
end