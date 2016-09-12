class Company < ActiveRecord::Base
  has_many :users
  has_many :invitations
  
  has_many :applications
  has_many :applicants, through: :applications, class_name: "User", foreign_key: :user_id
  
  has_many :jobs
  has_many :subsidiaries
  has_many :locations
  has_one :customer
  has_one :job_board
  has_many :payments
  has_many :activities
 
  validates_presence_of :name, :website

  def deactivate!
    update_column(:active, false)
  end
end