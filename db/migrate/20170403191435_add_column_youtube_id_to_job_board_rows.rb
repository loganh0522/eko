class AddColumnYoutubeIdToJobBoardRows < ActiveRecord::Migration
  def change
    add_column :job_board_rows, :youtube_id, :string
  end
end
