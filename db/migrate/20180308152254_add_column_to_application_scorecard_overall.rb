class AddColumnToApplicationScorecardOverall < ActiveRecord::Migration
  def change
    add_column :application_scorecards, :overall, :integer
  end
end
