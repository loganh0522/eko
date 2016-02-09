class HiringTeam < ActiveRecord::Base
  belongs_to :user 
  belongs_to :job

  attr_reader :user_tokens

  def user_tokens=(ids)
    self.user_id = ids.split(',') 
  end
end
