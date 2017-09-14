class AddColumnCandidateIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :candidate_id, :integer
  end
end
