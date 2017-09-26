class JobBoardHeader < ActiveRecord::Base
  belongs_to :job_board
  
  mount_uploader :logo, CareerPortalUploader
  mount_uploader :cover_photo, CareerPortalHeaderUploader

  after_update :crop_avatar
  
  def crop_avatar
    image.recreate_versions!(:large_image, :medium_image, :small_image) if crop_x.present?
  end 

  # validates_size_of :logo, maximum: 500.kilobytes,
  #                   message: "should be no more than 500 KB", if: :image_changed?

  # validates_property :format, of: :image, in: [:jpeg, :jpg, :png, :bmp], case_sensitive: false,
  #                    message: "should be either .jpeg, .jpg, .png, .bmp", if: :image_changed?
end