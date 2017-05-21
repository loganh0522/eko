class AddColumnCompanyIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :company_id, :integer
  end
end
