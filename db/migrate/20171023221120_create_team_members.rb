class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
      t.string :file 
      t.string :name
      t.string :position
      t.string :details
      t.integer :job_board_row_id
      t.timestamps

    end
  end
end
