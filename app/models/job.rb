class Job < ActiveRecord::Base
  belongs_to :company

  has_many :hiring_teams
  has_many :users, through: :hiring_teams
<<<<<<< HEAD
  has_many :stages

  has_many :applications 
  has_many :applicants, class_name: "User", through: :applications
  
  validates_presence_of :title, :benefits, :description, :country, :city, :province

  # attr_reader :user_tokens
=======
  has_many :stages, -> {order(:position)}
  
  validates_presence_of :title, :benefits, :description, :country, :city, :province


  has_many :applications
  has_many :applicants, through: :applications, class_name: "User", foreign_key: :user_id

  attr_reader :user_tokens

  def user_tokens=(ids)
    self.user_ids = ids.split(',') 
  end
>>>>>>> create_job

  # def user_tokens=(ids)
  #   self.user_ids = ids.split(',') 
  # end
end