class AddColumnFunctionIndustryToWorkExperience < ActiveRecord::Migration
  def change
    add_column :work_experiences, :function, :string
    add_column :work_experiences, :industry, :string
  end
end
