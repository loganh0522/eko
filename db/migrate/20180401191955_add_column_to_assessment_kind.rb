class AddColumnToAssessmentKind < ActiveRecord::Migration
  def change
    add_column :assessments, :kind, :string
    add_column :section_options, :scorecard_id, :integer
  end
end
