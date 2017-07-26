class CreateAssignedCandidates < ActiveRecord::Migration
  def change
    create_table :assigned_candidates do |t|
      t.integer :candidate_id
      t.integer :assignable_id
      t.integer :assignable_type
    end
  end
end
