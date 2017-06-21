class Resume < ActiveRecord::Base
  belongs_to :candidate

  mount_uploader :name, ResumeUploader
end