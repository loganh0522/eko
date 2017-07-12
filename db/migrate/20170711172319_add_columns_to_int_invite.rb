class AddColumnsToIntInvite < ActiveRecord::Migration
  def change
    add_column :interview_invitations, :message, :text
  end
end
