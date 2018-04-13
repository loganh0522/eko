class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :premium_board
  belongs_to :posting_duration
  belongs_to :job
  after_create :add_to_job_feed, :create_job_feed

  def add_to_job_feed
    self.update_attributes(job_id: self.order.job.id)
  end

  def create_job_feed
    if self.premium_board.name == "ZipRecruiter"
      if self.unit_price.to_i == 299
        ZiprecruiterPremiumFeed.create(job_id: self.order.job_id, 
        boost: true, posted_at: Time.now, premium_board_id: self.premium_board.id)
      else
        ZiprecruiterPremiumFeed.create(job_id: self.order.job_id, 
        boost: false, posted_at: Time.now, premium_board_id: self.premium_board.id)
      end
    end
  end

  def update_order_item

  end

  def send_email

  end
end