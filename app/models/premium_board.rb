class PremiumBoard < ActiveRecord::Base
  has_many :order_items, :dependent => :destroy
  has_many :posting_durations

  mount_uploader :logo, PremiumBoardLogoUploader

  accepts_nested_attributes_for :posting_durations, 
    allow_destroy: true
end