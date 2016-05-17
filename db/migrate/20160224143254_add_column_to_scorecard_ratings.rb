class AddColumnToScorecardRatings < ActiveRecord::Migration
  def change
    add_column :scorecard_ratings, :user_id, :integer
  end
end
