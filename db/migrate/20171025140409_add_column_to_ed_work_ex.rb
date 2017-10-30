class AddColumnToEdWorkEx < ActiveRecord::Migration
  def change
    add_column :work_experiences, :user_id, :integer
    add_column :educations, :user_id, :integer
    add_column :certifications, :user_id, :integer
  end
end
