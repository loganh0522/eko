class RejectionReason < ActiveRecord::Base
  belongs_to :company, -> {order("created_at DESC")}

end