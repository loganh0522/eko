class Logo < ActiveRecord::Base
  belongs_to :company

  mount_uploader :file, LogoUploader
end