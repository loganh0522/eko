class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :premium_board

  after_create :add_to_job_feed

  def add_to_job_feed
    

  end
end