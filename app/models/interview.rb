class Interview < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :job
  belongs_to :company
  has_many :event_ids, :dependent => :destroy
  
  has_many :assigned_users, as: :assignable, :dependent => :destroy
  has_many :users, through: :assigned_users, validate: false
  
  validates_presence_of :title, :kind, :date, :start_time, :end_time, :candidate_id
  
  searchkick

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
