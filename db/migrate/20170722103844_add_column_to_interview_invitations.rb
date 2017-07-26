class AddColumnToInterviewInvitations < ActiveRecord::Migration
  def change
    add_column :interview_invitations, :event_id, :string
  end
end
