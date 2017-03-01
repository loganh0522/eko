class ContactMessage < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :phone, :email, :message, :company
end