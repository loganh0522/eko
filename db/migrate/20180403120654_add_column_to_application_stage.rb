class AddColumnToApplicationStage < ActiveRecord::Migration
  def change
    add_column :application_stages, :stage_id, :integer
  end
end
