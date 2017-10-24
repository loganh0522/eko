class JobBoardHeader < ActiveRecord::Base
  belongs_to :job_board
  has_one :background_image

end