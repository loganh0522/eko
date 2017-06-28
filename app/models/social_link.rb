class SocialLink < ActiveRecord::Base
  belongs_to :user
  belongs_to :candidate
  before_create :filter_kind

  def filter_kind
  end
end