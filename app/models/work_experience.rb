class WorkExperience < ActiveRecord::Base
  belongs_to :user
  
  has_many :exp_industries
  has_many :industries, through: :exp_industries

  has_many :exp_functions
  has_many :functions, through: :exp_functions

  has_many :job_countries
  has_many :countries, through: :job_countries

  has_many :job_states
  has_many :states, through: :job_states

  has_many :accomplishments


  validates_presence_of :title, :company_name, :description

  # def order_by_date
  #   order = []
  #   month = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 
  #     'August', 'September', 'October', 'Novemeber', 'December']
    
  #   self.each do |experience| 
  #     if experience.current_position == 1 
  #       order[0] == (experience)
  #     end
  #   end
  # end

  # def current_experiences
  #   current_user.work_experiences.each do |experience| 
      
end 