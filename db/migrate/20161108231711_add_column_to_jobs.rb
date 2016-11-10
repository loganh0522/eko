class AddColumnToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :url, :string
  end
end
