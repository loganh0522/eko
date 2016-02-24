class RemoveColumnFromScorecardRatings < ActiveRecord::Migration
  def change
    remove_column :scorecard_ratings, :user_id
    remove_column :scorecard_ratings, :application_id
    add_column  :scorecard_ratings, :user_scorecard_id, :integer
  end
end
