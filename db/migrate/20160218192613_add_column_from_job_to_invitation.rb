class AddColumnFromJobToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :job, :integer
  end
end
