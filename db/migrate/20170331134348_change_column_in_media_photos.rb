class ChangeColumnInMediaPhotos < ActiveRecord::Migration
  def change
    rename_column :media_photos, :job_board_row, :job_board_row_id
  end
end
