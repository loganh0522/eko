class Tag < ActiveRecord::Base
  has_many :taggings
  belongs_to :company, dependent: :destroy

  before_create :titleize 

  def self.find_or_create_tag(name)
    name.titleize
    self.where(name: name, company: current_company).first_or_create
  end

  def titleize
    self.name = self.name.titleize
  end
end