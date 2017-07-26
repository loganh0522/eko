class RejectionReason < ActiveRecord::Base
  belongs_to :company, -> {order("created_at DESC")}

  validates_presence_of :body, :company_id
end