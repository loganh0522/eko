class CreateScorecard < ActiveRecord::Migration
  def change
    create_table :scorecards do |t|
      t.integer :job_id
      t.integer :application_id
    end
  end
end
