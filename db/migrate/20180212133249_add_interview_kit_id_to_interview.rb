class AddInterviewKitIdToInterview < ActiveRecord::Migration
  def change
    add_column :interviews, :interview_kit_id, :integer
  end
end
