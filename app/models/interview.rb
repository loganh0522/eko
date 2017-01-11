class Interview < ActiveRecord::Base
  belongs_to :application
  has_many :my_interviews
  has_many :users, through: :my_interviews
end