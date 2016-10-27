class CreateGoogleToken < ActiveRecord::Migration
  def change
    create_table :google_tokens do |t|
      t.string :access_token
      t.string :refresh_token
      t.datetime :expires_at
      t.integer :user_id
    end
  end
end
