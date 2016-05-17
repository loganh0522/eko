class ChangeColumnNameInApplicationScorecards < ActiveRecord::Migration
  def change
    remove_column :scorecard_ratings, :user_scorecard_id
    add_column  :scorecard_ratings, :application_scorecard_id, :integer
  end
end
