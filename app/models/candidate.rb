class Candidate < ActiveRecord::Base 
  

  liquid_methods :first_name, :last_name, :full_name
  searchkick
  # index_name ["talentwiz", Rails.env].join('_')
  before_create :generate_token, :downcase_email
  belongs_to :company
  belongs_to :user
  has_many :applications, :dependent => :destroy
  has_many :jobs, through: :applications
  has_one :conversation
  has_many :interviews
  
  has_many :invited_candidates
  has_many :interview_invitations, through: :invited_candidates
  has_many :resumes, :dependent => :destroy
  has_many :work_experiences, :dependent => :destroy
  has_many :educations, :dependent => :destroy
  has_many :social_links, :dependent => :destroy

  has_many :ratings
  has_many :taggings
  has_many :tags, through: :taggings
  
  has_many :messages, -> {order("created_at DESC")}, as: :messageable, :dependent => :destroy
  has_many :comments, -> {order("created_at DESC")}, as: :commentable, :dependent => :destroy
  has_many :tasks, as: :taskable, :dependent => :destroy

  validates_presence_of :first_name, :last_name, :email
  validates_associated :social_links, :work_experiences, :educations, :resumes
  
  accepts_nested_attributes_for :social_links, 
    allow_destroy: true

  accepts_nested_attributes_for :work_experiences, 
    allow_destroy: true

  accepts_nested_attributes_for :educations, 
    allow_destroy: true

  accepts_nested_attributes_for :resumes, 
    allow_destroy: true,
    reject_if: proc { |a| a[:name].blank? }

  def full_name
    if self.manually_created
      full_name = "#{self.first_name} #{self.last_name}"
    else 
      full_name = "#{self.user.first_name} #{self.user.last_name}"
    end
    return full_name
  end

  def downcase_email
    self.email = self.email.downcase
  end
  
  def generate_token
    self.token = SecureRandom.urlsafe_base64
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

  def current_user_rating_present?(current_user)
    self.ratings.each do |rating| 
      if rating.user == current_user
        return true   
      end
    end
    return false
  end

  def open_tasks
    self.tasks.where(status: 'active')
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
    self.ratings.average(:score).to_f.round(1) if ratings.any?
  end

  def search_data
    attributes.merge(
      comments: comments.map(&:id),
      jobs: jobs.map(&:id),
      resumes: resumes.map(&:id),
      tags: tags.map(&:name)
    )
  end
  
end
