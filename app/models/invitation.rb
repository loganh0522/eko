class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: "User"
  belongs_to :company

  validates_presence_of :recipient_email, :message, :user_role

  before_create :generate_token
  
  def generate_token 
    self.token = SecureRandom.urlsafe_base64
  end
end