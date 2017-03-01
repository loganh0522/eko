class Demo < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :phone, :email, :message, :company, :company_size, :company_website
end