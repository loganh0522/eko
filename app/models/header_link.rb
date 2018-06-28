class HeaderLink < ActiveRecord::Base
  belongs_to :job_board, dependent: :destroy
  belongs_to :job_board_row, dependent: :destroy
  validates_presence_of :name
end