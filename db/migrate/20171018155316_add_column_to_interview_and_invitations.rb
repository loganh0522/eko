class AddColumnToInterviewAndInvitations < ActiveRecord::Migration
  def change
    add_column :interviews, :details, :text
    add_column :interview_invitations, :details, :text
  end
end
