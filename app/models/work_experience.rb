 class WorkExperience < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :profile, touch: true
  belongs_to :candidate, touch: true
  
  has_many :exp_industries
  has_many :industries, through: :exp_industries

  has_many :exp_functions
  has_many :functions, through: :exp_functions

  has_many :user_skills
  has_many :skills, through: :user_skills


  has_many :accomplishments


  validates_presence_of :title, :message => "Job title can't be blank"
  validates_presence_of :company_name, :message => "Company can't be blank"
  validates_presence_of :description, :message => "Description can't be blank"
  validates_presence_of :start_month, :message => "Start Month can't be blank"
  validates_presence_of :start_year, :message => "Start Year can't be blank"
  validates_presence_of :industry_ids, :message => "Industry can't be blank"
  validates_presence_of :function_ids, :message => "Function can't be blank"
  validates_presence_of :end_month, :end_year, :unless => :current_position?
  validates_presence_of :current_position, :unless => :end_year?

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