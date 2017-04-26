class AddCandidateIdToMultipleTables < ActiveRecord::Migration
  def change
    add_column :applications, :candidate_id, :integer
    add_column :messages, :candidate_id, :integer
    add_column :tags, :candidate_id, :integer
  end
end
