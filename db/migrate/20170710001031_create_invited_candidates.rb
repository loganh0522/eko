class CreateInvitedCandidates < ActiveRecord::Migration
  def change
    create_table :invited_candidates do |t|
      t.integer :interview_invitation_id
      t.integer :candidate_id
    end
  end
end
