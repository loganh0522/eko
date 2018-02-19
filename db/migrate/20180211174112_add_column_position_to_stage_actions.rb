class AddColumnPositionToStageActions < ActiveRecord::Migration
  def change
    add_column :stage_actions, :position, :integer
    add_column :stage_actions, :title, :string
    add_column :stage_actions, :due_date, :datetime
  end
end
