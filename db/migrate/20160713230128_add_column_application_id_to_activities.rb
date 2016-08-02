class AddColumnApplicationIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :application_id, :integer
  end
end
