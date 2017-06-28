class Candidate < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks  
  index_name ["talentwiz", Rails.env].join('_') 

  # after_commit on: [:update] do
  #   __elasticsearch__.update_document if self.published?
  # end

  liquid_methods :first_name, :last_name, :full_name
  before_create :generate_token
  belongs_to :company
  belongs_to :user
  has_many :applications, :dependent => :destroy
  has_many :jobs, through: :applications


  has_many :resumes, :dependent => :destroy
  has_many :work_experiences, :dependent => :destroy
  has_many :educations, :dependent => :destroy
  has_many :social_links, :dependent => :destroy

  has_many :ratings
  has_many :taggings
  has_many :tags, through: :taggings
  
  has_many :messages, as: :messageable, :dependent => :destroy
  has_many :comments, -> {order("created_at DESC")}, as: :commentable, :dependent => :destroy
  has_many :tasks, as: :taskable, :dependent => :destroy

  accepts_nested_attributes_for :social_links, 
    allow_destroy: true,
    reject_if: proc { |a| a[:url].blank? }

  accepts_nested_attributes_for :work_experiences, 
    allow_destroy: true,
    reject_if: proc { |a| a[:title].blank? }

  accepts_nested_attributes_for :educations, 
    allow_destroy: true,
    reject_if: proc { |a| a[:school].blank? }

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

  def tags_present
    @tags = []
    self.tags.each do |tag| 
      @tags.append(tag.name)
    end
    return @tags
  end


  def as_indexed_json(options={})
    as_json(
      only: [:id, :first_name, :last_name, :email, :full_name, :manually_created, :created_at],
      include: {
        educations: {only: [:id, :title, :description, :school]},
        work_experiences: {only: [:id, :title, :description, :company_name]},
        tags: {only: [:name]},
        user: {
          only: [:id, :first_name, :last_name, :tag_line],
          include: {
            profile: {
              include: {
                educations: {only: [:id, :title, :description, :school]},
                work_experiences: {only: [:id, :title, :description, :company_name]}
              }
            }
          }
        },
        applications: {
          only: [:id, :created_at],
          include: {
            stage: {only: [:name]},
            job: {only: [:title, :location, :status]},
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
            "applications.tags.name" => "#{tag}"
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
    
    if options[:job_status].present? 
      options[:job_status].each do |status| 
        search_definition[:query][:bool][:must] << {
         match: { 
            "applications.job.status" => "#{status}"
          }
        }
      end
    end

    if options[:job_applied].present? 
      options[:job_applied].each do |title| 
        search_definition[:query][:bool][:must] << {
         match: { 
            "applications.job.title" => "#{title}"
          }
        }
      end
    end

    if options[:location_applied].present? 
      options[:location_applied].each do |location| 
        search_definition[:query][:bool][:must] << {
         match: { 
            "applications.job.location" => "#{location}"
          }
        }
      end
    end

    __elasticsearch__.search(search_definition)
  end
end
