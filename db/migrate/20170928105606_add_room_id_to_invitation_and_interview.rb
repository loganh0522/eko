class AddRoomIdToInvitationAndInterview < ActiveRecord::Migration
  def change
    add_column :interview_invitations, :room_id, :integer
    add_column :interviews, :room_id, :integer
  end
end
