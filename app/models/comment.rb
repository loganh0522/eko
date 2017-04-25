class Comment < ActiveRecord::Base
  belongs_to :user
  has_many :mentions
  belongs_to :commentable, polymorphic: true
end