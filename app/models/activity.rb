class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :company, -> {order("created_at DESC")}
  belongs_to :job
  
  belongs_to :trackable, polymorphic: true

  def search_data
    attributes.merge(
      comments: comments.map(&:id),
      jobs: jobs.map(&:id),
      resumes: resumes.map(&:id),
      tags: tags.map(&:name),
      full_name: full_name
    )
  end
end