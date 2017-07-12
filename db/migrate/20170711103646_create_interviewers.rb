class CreateInterviewers < ActiveRecord::Migration
  def change
    create_table :invited_interviewers do |t|
      t.integer :user_id
      t.integer :interview_invitation_id
    end
  end
end
