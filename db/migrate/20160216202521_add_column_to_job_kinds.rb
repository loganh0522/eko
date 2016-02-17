class AddColumnToJobKinds < ActiveRecord::Migration
  def change
    add_column :job_kinds, :job_type_id, :integer
    add_column :job_kinds, :name, :string
  end
end
