class AddColumnToScorecardRatingNote < ActiveRecord::Migration
  def change
    add_column :scorecard_ratings, :body, :text
  end
end
