class CreateOutlookToken < ActiveRecord::Migration
  def change
    create_table :outlook_tokens do |t|
      t.string :access_token
      t.string :refresh_token
      t.integer :user_id
      t.datetime :expires_at
      t.timestamps
    end
  end
end
