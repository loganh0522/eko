class Application < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks 
  index_name ["talentwiz", Rails.env].join('_') 

  before_create :generate_token
  belongs_to :company
  
  belongs_to :candidate

  belongs_to :applicant, class_name: 'User', foreign_key: :user_id
  belongs_to :apps, class_name: 'Job', foreign_key: :job_id 
  

  belongs_to :stage


  has_many :comments, -> {order("created_at DESC")}, as: :commentable 
  has_many :messages, as: :messageable
  has_many :application_scorecards
  has_many :activities, -> {order("created_at DESC")}  
  has_many :question_answers, dependent: :destroy
  accepts_nested_attributes_for :question_answers, allow_destroy: true
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :interviews
  has_many :ratings

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

  def tags_present
    @tags = []
    self.tags.each do |tag| 
      @tags.append(tag.name)
    end
    return @tags
  end

  # def current_position
  #   self.applicant.profile.current_position.title
  # end
        

  def as_indexed_json(options={})
    as_json(
      methods: [:average_rating, :tags_present],
      only: [:created_at, :rejection_reason, :source, :manually_created],
      include: {
        stage: {only: [:name]},
        apps: {only: [:title, :location, :status]},
        tags: {only: [:name]},            
        
        candidate: {
          only: [:first_name, :last_name, :email],
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
            }
          }
        }
      }
    )
  end


  # def self.search(query, options={})
    # search_definition = {
    #   query: {
    #     multi_match: {
    #       query: query,
    #       fields: ["applicant.first_name", "applicant.last_name", "applicant.tag_line",
    #         "applicant.profile.work_experiences.description", "applicant.profile.work_experiences.title", 
    #         "applicant.profile.work_experiences.company_name", 'applicant.profile.education.school' ]
    #     }
    #   }
    # }

    # if options[:average_rating].present? 
    #   search_definition = {
    #     filter: {
    #       range: {
    #         average_rating: {
    #           gte: (options[:average_rating].first.to_f),
    #           lt: 5.1
    #         }
    #       }
    #     }
    #   }
    # end


    # if options[:tags].present? 
    #   search_definition = {

    #     filter: {
    #       match: {
    #         "tags.name" => 
    #           options[:tags].join(" ")
    #       }
    #     }
    #   }
    # end
    
    
    # if option[:job_status].present? 
    #   search_definition[:filter] = {
    #     query: {
    #       bool: {
    #         apps: {
    #           fields: [:status],
    #           options[:job_status]
    #         } 
    #       }
    #     }
    #   }
    # end

    # if options[:date_applied].present?
    # end

    # if date_field.present? 
    #   search_definition[:query][:multi_match][:fields] << "created_at"
    # end
  def self.search(query, options={})
    search_definition = {
      # query: {
      #   # multi_match: {
      #   #   query: query,
      #   #   fields: ["candidate.first_name", "candidate.last_name", "candidate.email",
      #   #     "candidate.user.first_name", "candidate.user.last_name", "candidate.user.email"]
      #   # },
      # },
      filter: {
        range: {
          average_rating: {
            gte: (options[:average_rating].first.to_f),
            lt: 5.1
          }
        }
      }
    }
        # },
        # terms: { 
        #   "tags.name" => options[:tags]
        # }
        # nested: {
        #   path: 'tags',
        #   query: {
        #     filter:{
        #       terms: { 
        #         "tags.name" => options[:tags]
        #       }
        #     }
        #   }
        # }
    __elasticsearch__.search(search_definition)
  end
end