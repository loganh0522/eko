class ClientContact < ActiveRecord::Base
  belongs_to :client
  has_many :messages, as: :messageable
  has_many :comments, as: :commentable
  has_many :tasks, as: :taskable

  validates_presence_of :first_name, :last_name
end