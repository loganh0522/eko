class EditJobTable < ActiveRecord::Migration
  def change
    add_column :jobs, :address, :string
    add_column :jobs, :location, :string
    add_column :jobs, :start_salary, :string
    add_column :jobs, :end_salary, :string
  end
end
