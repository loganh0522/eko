class AddColumnToInterviewTimes < ActiveRecord::Migration
  def change
    add_column :interview_times, :interview_invitation_id, :integer
    remove_column :interview_times, :interview_invitation
    add_column :interview_invitations, :duration, :string
  end
end
