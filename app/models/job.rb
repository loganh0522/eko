class Job < ActiveRecord::Base
  belongs_to :company

  has_many :hiring_teams
  has_many :users, through: :hiring_teams
  has_many :stages
  
  validates_presence_of :title, :benefits, :description, :country, :city, :province


  has_many :applications
  has_many :users, through: :applications

  attr_reader :user_tokens

  def user_tokens=(ids)
    self.user_ids = ids.split(',') 
  end

end