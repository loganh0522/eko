class Room < ActiveRecord::Base
  belongs_to :company
  has_one :outlook_token

  validates_presence_of :name, :email
  validates_uniqueness_of :email
  before_create :downcase_email

  def downcase_email
    self.email = self.email.downcase
  end
end