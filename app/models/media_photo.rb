class MediaPhoto < ActiveRecord::Base
  belongs_to :job_board_row

  mount_uploader :file_name, MediaPhotosUploader
end