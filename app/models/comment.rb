class Comment < ActiveRecord::Base
  belongs_to :application
  belongs_to :user
  has_many :mentions
end