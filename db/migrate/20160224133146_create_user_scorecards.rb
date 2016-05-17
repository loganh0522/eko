class CreateUserScorecards < ActiveRecord::Migration
  def change
    create_table :user_scorecards do |t|
      t.integer :scorecard_id, :user_id, :job_id
      t.text :feedback
    end
  end
end
