class Country < ActiveRecord::Base
  has_many :states 

  has_many :job_countries
  has_many :work_experiences, through: :job_countries

end