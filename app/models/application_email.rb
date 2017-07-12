class ApplicationEmail < ActiveRecord::Base
  belongs_to :company
  belongs_to :job

  validates_presence_of :subject, :body
end