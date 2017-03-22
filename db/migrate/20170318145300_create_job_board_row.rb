class CreateJobBoardRow < ActiveRecord::Migration
  def change
    create_table :job_board_rows do |t|
      t.integer :job_board_id
      t.string :header
      t.string :subheader
      t.string :description
      t.string :video_link
      t.integer :position
      t.string :job_filters
      t.timestamps
    end
  end
end
