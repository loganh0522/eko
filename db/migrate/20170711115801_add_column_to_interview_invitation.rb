class AddColumnToInterviewInvitation < ActiveRecord::Migration
  def change
    add_column :interview_invitations, :job_id, :integer
    add_column :interview_invitations, :company_id, :integer
    remove_column :interview_invitations, :interview_id
    remove_column :interview_invitations, :candidate_id
  end
end
