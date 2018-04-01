class Subsidiary < ActiveRecord::Base 
  belongs_to :company
  belongs_to :subsidiary, :class_name => "Company"
end