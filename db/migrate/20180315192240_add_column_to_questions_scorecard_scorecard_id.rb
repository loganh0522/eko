class AddColumnToQuestionsScorecardScorecardId < ActiveRecord::Migration
  def change
    add_column :questions, :scorecard_id, :integer 
    add_column :questions, :guidelines, :text
  end
end
