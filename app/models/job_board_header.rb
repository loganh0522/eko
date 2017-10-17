class JobBoardHeader < ActiveRecord::Base
  belongs_to :job_board
  
  mount_uploader :logo, CareerPortalUploader
  mount_uploader :cover_photo, CareerPortalHeaderUploader

  after_update :crop_avatar
  
  def crop_avatar
    logo.recreate_versions!(:large_logo) 
  end 
end