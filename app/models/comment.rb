class Comment < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks 
  index_name ["talentwiz", Rails.env].join('_') 

  belongs_to :user
  has_many :mentions
  belongs_to :commentable, polymorphic: true

  def as_indexed_json(options={})
    as_json(
      only: [:created_at, :application_id, :candidate_id, :body]
    )
  end

end