class Client < ActiveRecord::Base
  belongs_to :company
  has_many :client_contacts
  has_many :jobs
  has_many :messages, as: :messageable
  has_many :comments, as: :commentable
  has_many :tasks, as: :taskable

end