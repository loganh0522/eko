class Interview < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks 
  index_name ["talentwiz", Rails.env].join('_') 
  
  # def as_indexed_json(options={})
  #   as_json(
  #     only: [:location, :kind, :title, :status]
  #     include: {
  #       users: {only: [:first_name, :last_name, :full_name],
  #         job: {only: [:title]}
  #       }
  #     }
  #   )
  # end


  belongs_to :candidate
  belongs_to :job

  has_many :assigned_users, as: :assignable
  has_many :users, through: :assigned_users


  def month
    Date.parse(self.date).strftime("%B")
  end

  def day
    Date.parse(self.date).strftime("%d")
  end

  def year
    Date.parse(self.date).strftime("%Y")
  end



end
