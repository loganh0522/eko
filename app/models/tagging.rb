class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :application, touch: true
end