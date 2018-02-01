class Application < ActiveRecord::Base  
  before_create :generate_token
  belongs_to :company
  belongs_to :stage
  belongs_to :candidate
  belongs_to :job

  has_many :ratings
  has_many :application_scorecards
  
  has_many :question_answers, dependent: :destroy

  after_create :reindex_candidate

  def reindex_candidate
    Candidate.find(candidate.id).reindex
  end

  accepts_nested_attributes_for :question_answers, allow_destroy: true
  
  

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end


  ######### ElasticSearch ##############

  def app_stage
    applied = "Applied"
    rejected = "Rejected"
    if self.rejected == true
      return rejected
    elsif self.stage.present?
      self.stage.name
    elsif 
      applied
    end
  end

  def current_user_rating_present?(current_user, application)
    application.ratings.each do |rating| 
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

  def average_rating 
    self.ratings.average(:score).to_f.round(1) if ratings.any?
  end

  # def current_position
  #   self.applicant.profile.current_position.title
  # end
end