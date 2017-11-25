class AddUserEmailToGoogleToken < ActiveRecord::Migration
  def change
    add_column :google_tokens, :email, :string
    add_column :outlook_tokens, :email, :string
  end
end
