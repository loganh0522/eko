class Application < ActiveRecord::Base
  include Elasticsearch::Model 
  include Elasticsearch::Model::Callbacks 
  index_name ["talentwiz", Rails.env].join('_') 

  before_create :generate_token


  belongs_to :company
  belongs_to :applicant, class_name: 'User', foreign_key: :user_id
  belongs_to :apps, class_name: 'Job', foreign_key: :job_id 
  

  belongs_to :stage
  

  has_many :comments, -> {order("created_at DESC")}
  has_many :application_scorecards
  has_many :messages, -> {order("created_at DESC")}
  has_many :activities, -> {order("created_at DESC")}

  has_many :question_answers, dependent: :destroy
  accepts_nested_attributes_for :question_answers, allow_destroy: true

  has_many :taggings
  has_many :tags, through: :taggings


  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  ########### Tagging #############

  def self.tagged_with(name)
    Tag.find_by_name!(name).articles
  end

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count").
      joins(:taggings).group("taggings.tag_id")
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  ######### ElasticSearch ##############

  
  def as_indexed_json(options={})
    as_json(
      only: [:created_at],
      include: {
        applicant: {
          only: [:first_name, :last_name, :tag_line],
          include: {
            user_avatar: {only: [:image, :small_image]},
            work_experiences: {only: [:title, :description, :company_name]}
          }        
        }
      }
    )
  end

  def self.search(query, options={})
    search_definition = {
      query: {
        multi_match: {
          query: query,
          fields: ["applicant.first_name", "applicant.last_name", "applicant.tag_line",
            "applicant.work_experiences.description", "applicant.work_experiences.title", 
            "applicant.work_experiences.company_name", 'applicant.education.school' ]
        }
      }
    }

    # if date_field.present? 
    #   search_definition[:query][:multi_match][:fields] << "created_at"
    # end
    __elasticsearch__.search(search_definition)
  end
end