class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_one :activity, as: :trackable, :dependent => :destroy

  validates_presence_of :body
  searchkick
end