class ApplicationEmail < ActiveRecord::Base
  belongs_to :company
  belongs_to :job
end