class ZiprecruiterPremiumFeed < ActiveRecord::Base
  belongs_to :job
  belongs_to :premium_board
end