class AddColumnToApplicationStageStageId < ActiveRecord::Migration
  def change
    add_column :applications, :reviewed, :boolean
  end
end
