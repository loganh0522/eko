class CreateJobBoardHeader < ActiveRecord::Migration
  def change
    create_table :job_board_headers do |t|
      t.integer :job_board_id
      t.string :header 
      t.string :subheader
      t.string :cover_photo
      t.string :logo
      t.string :layout
      t.string :color_overlay
      t.timestamps
    end
  end
end
