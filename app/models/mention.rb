class Mention < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment
  belongs_to :mentioned, :class_name => "User"
end