class Customer < ActiveRecord::Base
  belongs_to :company
  has_one :subscription
end