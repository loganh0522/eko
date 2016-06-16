class UserAvatar < ActiveRecord::Base
  belongs_to :user 

  mount_uploader :image, MediumUserImageUploader
end