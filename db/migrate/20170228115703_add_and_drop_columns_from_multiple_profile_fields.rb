class AddAndDropColumnsFromMultipleProfileFields < ActiveRecord::Migration
  def change
    remove_column :work_experiences, :user_id
    add_column :work_experiences, :location, :string
    add_column :work_experiences, :position, :integer

    remove_column :educations, :user_id

    remove_column :user_certifications, :user_id
    add_column :user_certifications, :name, :string
  end
end
