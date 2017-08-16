class Message < ActiveRecord::Base 
  belongs_to :user
  belongs_to :messageable, polymorphic: true

  validates_presence_of :subject, :body
end