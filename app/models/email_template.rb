class EmailTemplate < ActiveRecord::Base
  belongs_to :user
  belongs_to :company

  validates_presence_of :company_id, :title, :body, :subject
end