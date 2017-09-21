class SocialLink < ActiveRecord::Base
  belongs_to :user
  belongs_to :candidate
  after_validation :add_http
  before_update :add_http
  validates_presence_of :url, :kind

  def filter_kind
    ["LinkedIn", "Facebook", "Twitter", "Google+", "Tumblr", 
    "Dribbble", "GitHub", "BitBucket", "AngelList", "YouTube", 
    "Medium", "Vimeo", "Pinterest", "Flickr", "Personal", "Other"]
  end

  def add_http
    if self.url[0..3] != "http"
      self.url = "https://" + self.url
    end
  end
end
 
