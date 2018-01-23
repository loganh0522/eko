class HeaderLink < ActiveRecord::Base
  belongs_to :job_board
  belongs_to :job_board_row
  validates_presence_of :name
end