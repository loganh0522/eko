class CreateHiringTeams < ActiveRecord::Migration
  def change
    create_table :hiring_teams do |t|
      t.integer :user_id
      t.integer :job_id
    end
  end
end
