class JobBoardHeader < ActiveRecord::Base
  belongs_to :job_board
  
  mount_uploader :logo, CareerPortalUploader
  mount_uploader :cover_photo, CareerPortalHeaderUploader
end