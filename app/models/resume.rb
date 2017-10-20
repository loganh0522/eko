class Resume < ActiveRecord::Base
  belongs_to :candidate
  mount_uploader :name, ResumeUploader

  validates_presence_of :name, :candidate_id
end