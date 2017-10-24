class RemoveColumnsFromJobBoardHeader < ActiveRecord::Migration
  def change
    remove_column :job_board_headers, :logo
    remove_column :job_board_headers, :cover_photo
  end
end
