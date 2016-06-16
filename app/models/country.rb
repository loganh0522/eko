class Country < ActiveRecord::Base
  has_many :states 

  has_many :job_countries
end