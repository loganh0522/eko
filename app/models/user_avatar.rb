class UserAvatar < ActiveRecord::Base
  belongs_to :user 
  mount_uploader :image, AvatarUploader

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  
  after_update :crop_avatar
  
  def crop_avatar
    image.recreate_versions!(:thumb, :large_image, :medium_image, :small_image) if crop_x.present?
    self.image = image
  end 
end