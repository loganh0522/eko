class CreatePremiumFeeds < ActiveRecord::Migration
  def change
    create_table :ziprecruiter_premium_feeds do |t|
      t.integer :job_id
      t.integer :premium_board_id
      t.datetime :posted_at
      t.boolean :zip_recruiter_boost
      t.timestamps
    end
  end
end
