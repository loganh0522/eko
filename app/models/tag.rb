class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  belongs_to :company
  belongs_to :project
  before_create :titleize 

  validates_presence_of :name

  def self.find_or_create_tag(name)
    name.titleize
    self.where(name: name, company: current_company).first_or_create
  end

  def titleize
    self.name = self.name.titleize
  end
end