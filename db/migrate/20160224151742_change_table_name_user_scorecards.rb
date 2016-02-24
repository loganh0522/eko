class ChangeTableNameUserScorecards < ActiveRecord::Migration
  def change
    add_column  :user_scorecards, :application_id, :integer
    rename_table :user_scorecards, :application_scorecards
  end
end
