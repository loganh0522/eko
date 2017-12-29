class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :premium_board
  belongs_to :posting_duration
  after_create :add_to_job_feed

  def add_to_job_feed
    binding.pry
  end

  def send_email

  end
end