class AddUserIdToJobStates < ActiveRecord::Migration
  def change
    add_column :job_states, :user_id, :integer
  end
end
