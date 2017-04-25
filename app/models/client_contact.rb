class ClientContact < ActiveRecord::Base
  belongs_to :client
  has_many :messages, as: :messageable
  has_many :comments, as: :commentable
end