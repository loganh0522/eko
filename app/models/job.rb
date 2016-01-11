class Job < ActiveRecord::Base
  belongs_to :company

  has_many :hiring_teams
  has_many :users, through: :hiring_teams

  validates_presence_of :title, :benefits, :description, :country, :city, :province
end