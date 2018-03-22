class Resume < ActiveRecord::Base
  belongs_to :candidate
  mount_base64_uploader :name, ResumeUploader, file_name: -> (r) { r.candidate.full_name + "_resume"}

  validates_presence_of :name
end