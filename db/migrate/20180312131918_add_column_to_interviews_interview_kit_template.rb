class AddColumnToInterviewsInterviewKitTemplate < ActiveRecord::Migration
  def change
    add_column :interviews, :interview_kit_template_id, :integer
  end
end
