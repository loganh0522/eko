class AddColumnJobIdToActivites < ActiveRecord::Migration
  def change
    add_column :activities, :job_id, :integer
  end
end
