class UserAvatar < ActiveRecord::Base
  belongs_to :user 
  mount_uploader :image, AvatarUploader
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  
  after_save :crop_avatar
 
  def crop_avatar
    image.recreate_versions! if crop_x.present?
  end 
end