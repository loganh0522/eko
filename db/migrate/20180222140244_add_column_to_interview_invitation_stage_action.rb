class AddColumnToInterviewInvitationStageAction < ActiveRecord::Migration
  def change
    add_column :interview_invitations, :stage_action_id, :integer
    add_column :interview_invitations, :interview_kit_id, :integer
  end
end
