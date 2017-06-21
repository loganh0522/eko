class ChangeColumnJobInInvitation < ActiveRecord::Migration
  def change
    rename_column :invitations, :job, :job_id
  end
end
