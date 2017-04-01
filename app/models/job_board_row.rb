class JobBoardRow < ActiveRecord::Base
  belongs_to :job_board
  has_many :media_photos

  accepts_nested_attributes_for :media_photos, allow_destroy: true
end