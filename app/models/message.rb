class Message < ActiveRecord::Base 
  belongs_to :application
  belongs_to :user
end