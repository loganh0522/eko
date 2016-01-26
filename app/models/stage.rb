class Stage < ActiveRecord::Base 
  belongs_to :job

  has_many :applications
  has_many :applicants, through: :applications, class_name: "User", foreign_key: :user_id

  validates_numericality_of :position, only_integer: true
end 