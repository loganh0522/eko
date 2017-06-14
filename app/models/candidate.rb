class Candidate < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks  
  index_name ["talentwiz", Rails.env].join('_') 

  liquid_methods :first_name, :last_name, :full_name
  before_create :generate_token

  belongs_to :company
  belongs_to :user
  
  has_many :applications, :dependent => :destroy
  has_many :ratings
  
  has_many :messages, as: :messageable, :dependent => :destroy
  has_many :comments, -> {order("created_at DESC")}, as: :commentable, :dependent => :destroy
  has_many :tasks, as: :taskable, :dependent => :destroy

  has_many :work_experiences, :dependent => :destroy
  has_many :educations, :dependent => :destroy

  accepts_nested_attributes_for :work_experiences, 
    allow_destroy: true
    # reject_if: :experience_validation

  accepts_nested_attributes_for :educations, 
    allow_destroy: true
    # reject_if: proc { |a| a[:body].blank? }

  def full_name
    full_name = "#{self.first_name} #{self.last_name}"
    return full_name
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


  def as_indexed_json(options={})
    as_json(
      only: [:first_name, :last_name, :email, :manually_created],
      include: {
        educations: {only: [:title, :description, :school]},
        work_experiences: {only: [:title, :description, :company_name]},
        user: {
          only: [:first_name, :last_name, :tag_line],
          include: {
            profile: {
              include: {
                educations: {only: [:title, :description, :school]},
                work_experiences: {only: [:title, :description, :company_name]}
              }
            }
          }
        },
        applications: {
          only: [:created_at],
          include: {
            stage: {only: [:name]},
            apps: {only: [:title, :location, :status]},
            tags: {only: [:name]},
          }
        }
      }
    )
  end
end
