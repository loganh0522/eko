class Resume < ActiveRecord::Base
  belongs_to :candidate
  # mount_uploader :name, ResumeUploader
  mount_base64_uploader :name, ResumeUploader

  validates_presence_of :name
end