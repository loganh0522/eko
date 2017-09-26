class Conversation < ActiveRecord::Base 
  belongs_to :user
  belongs_to :candidate
  belongs_to :company
  has_many :messages, -> {order("created_at DESC")}, :dependent => :destroy
end