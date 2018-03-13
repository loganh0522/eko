class AddColumnToScorecardRatingScorecardAnswerId < ActiveRecord::Migration
  def change
    add_column :scorecard_ratings, :scorecard_answer_id, :integer
  end
end
