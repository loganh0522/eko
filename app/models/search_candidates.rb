  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks  
  # index_name ["talentwiz", Rails.env].join('_') 

  # mapping do
  #   indexes :company_id, type: 'integer'
  #   indexes :first_name, type: 'string'
  #   indexes :last_name, type: 'string'
  #   indexes :email, type: 'string'
  #   indexes :manually_created, type: 'boolean'
  #   indexes :full_name, type: "string"
  #   indexes :rating, type: "integer"
  #   indexes :created_at, type: "date"
  # end

  # after_commit lambda { __elasticsearch__.index_document(parent: company_id, routing: company_id) }, on: :create
  # after_commit lambda { __elasticsearch__.update_document(parent: company_id, routing: company_id) }, on: :update
  # after_commit lambda { __elasticsearch__.delete_document(parent: company_id, routing: company_id) }, on: :destroy

  # def as_indexed_json(options={})
  #   as_json(
  #     only: [:id, :first_name, :last_name, :email, :company_id, :manually_created, :created_at],
  #     methods: [:tags_present, :full_name],
  
  #     include: {
  #       educations: {only: [:id, :title, :description, :school]},
  #       work_experiences: {only: [:id, :title, :description, :company_name]},
  #       tags: {only: [:name]},
  #       user: {
  #         only: [:id, :first_name, :last_name, :tag_line],
  #         include: {
  #           profile: {
  #             include: {
  #               educations: {only: [:id, :title, :description, :school]},
  #               work_experiences: {only: [:id, :title, :description, :company_name]}
  #             }
  #           }
  #         }
  #       },
  #       applications: {
  #         only: [:id, :created_at],
  #         include: {
  #           stage: {only: [:name]},
  #           job: {only: [:title, :location, :status]},
  #         }
  #       }
  #     }
  #   )
  # end

  # def self.search_name(query)
  #   search_definition = {
  #     query: {
  #       multi_match: {
  #         query: query,
  #         fields: ["full_name"]
  #       }
  #     }
  #   }
  #   __elasticsearch__.search(search_definition)
  # end
  
  # def self.search(query, options={})
  #   search_definition = {
  #     query: {
  #       bool: {
  #         must:[]
  #       }
  #     }
  #   }

  #   # search_definition = {
  #   #   query: {
  #   #     has_parent: {
  #   #       parent_type: 'company',
  #   #       query: {
  #   #         match: {
  #   #           id: 1
  #   #         }
  #   #       }
  #   #     },
  #   #     bool: {
  #   #       must:[]
  #   #     }  
  #   #   }
  #   # }
  #   if query.present?
  #     search_definition[:query][:bool][:must] << {
  #       multi_match: {
  #         query: query,
  #         fields: ["full_name"],
  #         operator: 'and'
  #       }
  #     }
  #   end

  #   if options[:average_rating].present? 
  #     search_definition[:query][:bool][:must] << {
  #       filtered: {
  #         filter: {
  #           range: {
  #             average_rating: {
  #               gte: (options[:average_rating].first.to_f),
  #               lt: 5.1
  #             }
  #           }
  #         }
  #       }
  #     }
  #   end

  #   if options[:tags].present? 
  #     options[:tags].each do |tag|
  #       search_definition[:query][:bool][:must] << {
  #         match: { 
  #           "tags.name" => "#{tag}"
  #         }
  #       }
  #     end
  #   end

  #   if options[:date_applied].present?
  #     search_definition[:query][:bool][:must] << {
  #       filtered: {
  #         filter: {
  #           range: {
  #             created_at: {
  #               gte: "now-2M",
  #               lte: "now",
  #               format: "epoch_millis"             
  #             }
  #           }
  #         }
  #       }
  #     }
  #   end
    
  #   if options[:job_status].present? 
  #     options[:job_status].each do |status| 
  #       search_definition[:query][:bool][:must] << {
  #        match: { 
  #           "applications.job.status" => "#{status}"
  #         }
  #       }
  #     end
  #   end

  #   if options[:job_applied].present? 
  #     options[:job_applied].each do |title| 
  #       search_definition[:query][:bool][:must] << {
  #        match: { 
  #           "applications.job.title" => "#{title}"
  #         }
  #       }
  #     end
  #   end

  #   if options[:location_applied].present? 
  #     options[:location_applied].each do |location| 
  #       search_definition[:query][:bool][:must] << {
  #        match: { 
  #           "applications.job.location" => "#{location}"
  #         }
  #       }
  #     end
  #   end

  #   __elasticsearch__.search(search_definition)
  # end