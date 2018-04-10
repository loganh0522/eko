class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :company

  validates_presence_of :recipient_email, :message, :first_name, :last_name, :permission_id

  before_create :generate_token
  
  def generate_token 
    self.token = SecureRandom.urlsafe_base64
  end
end