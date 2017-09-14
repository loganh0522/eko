class AddColumnStageIdToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :stage_id, :integer
  end
end
