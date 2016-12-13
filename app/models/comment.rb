class Comment < ActiveRecord::Base
  belongs_to :application
  has_many :mentions
end