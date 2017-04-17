class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :application, touch: true
end