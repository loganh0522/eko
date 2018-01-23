class JobBoardRow < ActiveRecord::Base
  belongs_to :job_board
  has_many :media_photos, :dependent => :destroy
  has_many :team_members, :dependent => :destroy
  has_one :background_image
  has_one :header_link
  
  accepts_nested_attributes_for :media_photos, allow_destroy: true
  accepts_nested_attributes_for :team_members, allow_destroy: true
end