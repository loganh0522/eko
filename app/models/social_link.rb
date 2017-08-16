class SocialLink < ActiveRecord::Base
  belongs_to :user
  belongs_to :candidate
  before_create :filter_kind

  validates_presence_of :url 

  def filter_kind
    ["LinkedIn", "Facebook", "Twitter", "Google+", "Tumblr", 
    "Dribbble", "GitHub", "BitBucket", "AngelList", "YouTube", 
    "Medium", "Vimeo", "Pinterest", "Flickr", "Personal", "Other"]
  end
end
 
