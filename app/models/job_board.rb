class JobBoard < ActiveRecord::Base
  belongs_to :company 

  mount_uploader :logo, CareerPortalUploader
end