class RemoveTableJobUsers < ActiveRecord::Migration
  def change
    drop_table :job_users
  end
end
