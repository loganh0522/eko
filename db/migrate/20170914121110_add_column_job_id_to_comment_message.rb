class AddColumnJobIdToCommentMessage < ActiveRecord::Migration
  def change
    add_column :comments, :job_id, :integer
    add_column :messages, :job_id, :integer
  end
end
