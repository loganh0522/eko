class EditColumnsInInterviews < ActiveRecord::Migration
  def change
    add_column :interviews, :candidate_id, :integer
  end
end
