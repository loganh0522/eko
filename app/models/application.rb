class Application < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks 
  index_name ["talentwiz", Rails.env].join('_') 

  after_commit on: [:update] do
    __elasticsearch__.update_document if self.published?
  end
  
  before_create :generate_token
  
  belongs_to :company
  belongs_to :stage, touch: true
  belongs_to :candidate, touch: true
  belongs_to :job, touch: true

  has_many :comments, -> {order("created_at DESC")}, as: :commentable, :dependent => :destroy
  has_many :tasks, as: :taskable, :dependent => :destroy

  has_many :ratings
  has_many :application_scorecards
  has_many :activities, -> {order("created_at DESC")}  
  
  has_many :question_answers, dependent: :destroy
  accepts_nested_attributes_for :question_answers, allow_destroy: true
  

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
  
  def all_tasks
    self.tasks
  end
  
  def open_tasks
    self.tasks.where(status: 'active')
  end

  def complete_tasks
    self.tasks.where(status: 'complete')
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

  def average_rating 
    self.ratings.average(:score).to_f.round(1) if ratings.any?
  end

  # def current_position
  #   self.applicant.profile.current_position.title
  # end
  mapping do 
    indexes :created_at, type: 'date'
  end
        

  def as_indexed_json(options={})
    as_json(
      methods: [:average_rating, :tags_present],   
      only: [:created_at, :rejection_reason, :source, :manually_created],
      include: {
        stage: {only: [:name]},
        job: {only: [:title, :location, :status]},        
        candidate: {
          only: [:first_name, :last_name, :email],
          include: {
            educations: {only: [:title, :description, :school]},
            work_experiences: {only: [:title, :description, :company_name]},
            tags: {only: [:name]},
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
            }
          }
        }
      }
    )
  end


  def self.search(query, options={})
    search_definition = {
      query: {
        bool: {
          must:[]
        }
      }
    }
    if query.present?
      search_definition[:query][:bool][:must] << {
        multi_match: {
          query: query,
          fields: %w(city state),
          operator: 'and'
        }
      }
    end

    if options[:average_rating].present? 
      search_definition[:query][:bool][:must] << {
        filtered: {
          filter: {
            range: {
              average_rating: {
                gte: (options[:average_rating].first.to_f),
                lt: 5.1
              }
            }
          }
        }
      }
    end

    if options[:tags].present? 
      options[:tags].each do |tag|
        search_definition[:query][:bool][:must] << {
          match: { 
            "tags.name" => "#{tag}"
          }
        }
      end
    end

    if options[:date_applied].present?
      search_definition[:query][:bool][:must] << {
        filtered: {
          filter: {
            range: {
              created_at: {
                gte: "now-2M",
                lte: "now",
                format: "epoch_millis"             
              }
            }
          }
        }
      }
    end

    __elasticsearch__.search(search_definition)
  end
end