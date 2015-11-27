class Location < ActiveRecord::Base
  belongs_to :company
  belongs_to :subsidiary
end