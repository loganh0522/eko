class QuestionAnswer < ActiveRecord::Base 
  belongs_to :application
  belongs_to :question
  belongs_to :candidate
  mount_base64_uploader :file, FileUploader
end