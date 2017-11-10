class AddColumnsIndustryFunctionToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :function, :string
    add_column :jobs, :industry, :string
  end
end
