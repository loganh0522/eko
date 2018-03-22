class AddColumnToInterviewInvitationIntervieKitTempId < ActiveRecord::Migration
  def change
    add_column :interview_invitations, :interview_kit_template_id, :integer
  end
end
