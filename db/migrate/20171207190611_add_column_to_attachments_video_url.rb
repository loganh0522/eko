class AddColumnToAttachmentsVideoUrl < ActiveRecord::Migration
  def change
    add_column :attachments, :video_url, :string
  end
end
