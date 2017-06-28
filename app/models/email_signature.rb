class EmailSignature < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :signature
end 