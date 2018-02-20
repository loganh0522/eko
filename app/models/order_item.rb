class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :premium_board
  belongs_to :posting_duration
  belongs_to :job
  after_create :add_to_job_feed, :update_order_item

  def add_to_job_feed
    self.update_attributes(job_id: self.order.job.id)


  end

  def update_order_item

  end

  def send_email

  end
end