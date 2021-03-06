class Candidate < ActiveRecord::Base 
  liquid_methods :first_name, :last_name, :full_name
  searchkick word_start: [:profile_w_titles, :work_titles, :work_description, :work_company, :education_description, :education_school, :full_name]
  # index_name ["talentwiz", Rails.env].join('_')
  belongs_to :company
  belongs_to :user
  has_many :applications, :dependent => :destroy
  has_many :jobs, through: :applications
  has_one :conversation, :dependent => :destroy
  has_many :interviews, :dependent => :destroy
  has_many :question_answers, :dependent => :destroy
  has_many :invited_candidates, :dependent => :destroy
  
  has_many :assessments, :dependent => :destroy
  has_many :questionairres, :dependent => :destroy

  has_many :interview_scorecards, :dependent => :destroy
  has_many :interview_invitations, through: :invited_candidates
  has_many :resumes, :dependent => :destroy
  has_many :work_experiences, :dependent => :destroy
  has_many :certifications, :dependent => :destroy
  has_many :educations, :dependent => :destroy
  has_many :social_links, :dependent => :destroy
  has_many :publications, :dependent => :destroy
  has_many :military_services, :dependent => :destroy
  has_many :awards, :dependent => :destroy
  has_many :patents, :dependent => :destroy
  has_many :candidate_associations, :dependent => :destroy


  has_many :ratings, :dependent => :destroy
  has_many :taggings, :dependent => :destroy
  has_many :tags, through: :taggings
  has_many :activities, -> {order("created_at DESC")}, :dependent => :destroy
  has_many :messages, -> {order("created_at DESC")}, as: :messageable, :dependent => :destroy
  has_many :comments, -> {order("created_at DESC")}, as: :commentable, :dependent => :destroy
  has_many :tasks, -> {order("created_at DESC")}, as: :taskable, :dependent => :destroy


  validates_presence_of :first_name, :last_name, :email, :if => :manually_created? && :internal_candidate?
  validates_associated :social_links, :work_experiences, :educations, :resumes
  
  before_create :generate_token, :downcase_email, :full_name, if: :manually_created? 
  before_create :generate_token, if: :not_manually_created?
  
  before_create :add_user_info_to_candidate, if: :user_present?
  
  accepts_nested_attributes_for :social_links, 
    allow_destroy: true
    
  accepts_nested_attributes_for :work_experiences, 
    allow_destroy: true

  accepts_nested_attributes_for :educations, 
    allow_destroy: true

  accepts_nested_attributes_for :resumes, 
    allow_destroy: true
    
  has_many :question_answers, dependent: :destroy
  accepts_nested_attributes_for :question_answers, allow_destroy: true

  def full_name
    if self.first_name == nil && self.last_name == nil
      full_name = "#{self.name}"
    else
      full_name = "#{self.first_name} #{self.last_name}"   
    end
    return full_name.capitalize
  end

  def downcase_email
    self.email = self.email.downcase
  end
  
  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  def manually_created?
    manually_created.present? && manually_created == true
  end

  def not_manually_created?
    !manually_created.present? || manually_created == false
  end

  def internal_candidate?
    self.source == "Internal"
  end

  def user_present? 
    self.user.present?
  end

  def add_user_info_to_candidate
    self.first_name = self.user.first_name 
    self.last_name = self.user.last_name
    self.full_name =  "#{self.user.first_name} #{self.user.last_name}"
    self.email = self.user.email
    self.phone = self.user.phone
    self.location = self.user.location
  end

  def job_comments(id)
    self.comments.where(job_id: id)
  end

  def notes
    @notes = []
    self.applications.each do |app|
      app.comments.each do |comment|
        @notes.append(comment) unless @notes.include?(comment)
      end
    end
    self.comments.each do |comment|
      @notes.append(comment) unless @notes.include?(comment)
    end
    return @notes
  end

  def current_jobs
    @current_jobs = self.work_experiences.where(current_position: true)
    return @current_jobs
  end


  ## Candidate Task Methods

  def open_tasks
    self.tasks.where(status: 'active')
  end

  def open_job_tasks(job)
    self.tasks.where(status: 'active', job_id: job.id)
  end

  def complete_job_tasks(job)
    self.tasks.where(status: 'complete', job_id: job.id)
  end
  def complete_tasks
    self.tasks.where(status: 'complete')
  end
  
  def tags_present
    @tags = []
    self.tags.each do |tag| 
      @tags.append(tag.name)
    end
    return @tags
  end

  def average_rating 
    @rating = self.ratings.average(:score).to_f.round(1) if ratings.any?
    return @rating
  end

  def avatar_url
    if !self.manually_created?
      if self.user.user_avatar.present?
        self.user.user_avatar.image.small_image.url 
      else
        return "undefined"
      end
    else
      return "undefined"
    end
  end

  def upcoming_interviews
    @interviews = []

    self.interviews.each do |interview| 
      if interview.start_time > Time.now
        @interviews.append(interview)
      end
    end
    
    return @interviews
  end

  def current_user_rating_present?(current_user)
    self.ratings.each do |rating| 
      if rating.user == current_user
        return true   
      end
    end
    
    return false
  end

  def current_user_rating(current_user)
    self.ratings.each do |rating| 
      if rating.user == current_user
        return rating.score 
      end
    end
    return false
  end

  def search_data
    attributes.merge(
      comments: comments.map(&:id),
      tags: tags.map(&:name),
      rating: average_rating,
      full_name: full_name,
      application_stage: applications.map(&:stage_id),
      application_rejected: applications.map(&:rejected),
      application_hired: applications.map(&:hired),
      jobs: jobs.map(&:id),
      job_title: jobs.map(&:title),
      job_status: jobs.map(&:status),
      job_location: jobs.map(&:location),
      resumes: resumes.map(&:id),
      work_titles: work_experiences.map(&:title),
      work_description: work_experiences.map(&:description),
      work_company: work_experiences.map(&:company_name),
      education_description: educations.map(&:description),
      education_school: educations.map(&:school)
    )
  end
end
