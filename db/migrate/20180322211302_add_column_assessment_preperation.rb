class AddColumnAssessmentPreperation < ActiveRecord::Migration
  def change
    add_column :assessments, :preperation, :text
  end
end
