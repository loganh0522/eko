class Job < ActiveRecord::Base
  belongs_to :company

  has_one :questionairre

  has_many :hiring_teams
  has_many :users, through: :hiring_teams
  
  has_many :stages, -> {order(:position)}
  
  validates_presence_of :title, :benefits, :description, :country, :city, :province

  has_many :applications
  has_many :applicants, through: :applications, class_name: "User", foreign_key: :user_id

end