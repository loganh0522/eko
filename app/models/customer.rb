class Customer < ActiveRecord::Base
  belongs_to :company
  has_one :subscription



  
  def convert_location
    location = self.location.split(',')
    if location.count == 3
      self.city = location[0] 
      self.state = location[1]
      self.country = location[2]
    else
      self.city = location[0] 
      self.country = location[1]
    end
  end
end