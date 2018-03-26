 class WorkExperience < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :candidate, touch: true

  has_many :user_skills, :dependent => :destroy
  has_many :skills, through: :user_skills
  
  has_many :accomplishments, :dependent => :destroy
  
  validates_presence_of :title, :message => "Job title can't be blank"
  validates_presence_of :company_name, :message => "Company can't be blank"
  validates_presence_of :description, :message => "Description can't be blank", if: :is_job_seeker?
  validates_presence_of :start_month, :message => "Start Month can't be blank", if: :is_job_seeker?
  validates_presence_of :start_year, :message => "Start Year can't be blank", if: :is_job_seeker?
  validates_presence_of :end_month, :end_year, :unless => :current_position?, if: :is_job_seeker?
  validates_presence_of :current_position, :unless => :end_year?, if: :is_job_seeker?

  accepts_nested_attributes_for :user_skills, 
    allow_destroy: true

  accepts_nested_attributes_for :accomplishments, 
    allow_destroy: true

  def is_job_seeker? 
    self.user.present? 
  end
  
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