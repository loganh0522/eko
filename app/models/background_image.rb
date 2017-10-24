class BackgroundImage < ActiveRecord::Base
  belongs_to :company
  belongs_to :job_board_header
  belongs_to :job_board_row
  belongs_to :user

  mount_uploader :file, BackgroundUploader
end