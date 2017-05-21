class Tag < ActiveRecord::Base
  has_many :taggings
  belongs_to :company

  def self.find_or_create_tag(name)
    name.capitalize
    self.where(name: name, company: current_company).first_or_create
  end
end