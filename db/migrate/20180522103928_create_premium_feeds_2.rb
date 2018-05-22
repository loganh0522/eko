class CreatePremiumFeeds2 < ActiveRecord::Migration
  def change
    create_table :premium_feeds do |t|
      t.integer :job_id
      t.integer :premium_board_id
      t.boolean :expired, default: false

      t.datetime :posted_at
      t.datetime :expiration_time
      t.timestamps
    end
  end
end
