class AddFileTypeToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :file_type, :string
    add_column :attachments, :file_image, :string
  end
end
