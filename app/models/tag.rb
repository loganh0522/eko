class Tag < ActiveRecord::Base
  has_many :taggings
  belongs_to :company
end