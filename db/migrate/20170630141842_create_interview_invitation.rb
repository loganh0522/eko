class CreateInterviewInvitation < ActiveRecord::Migration
  def change
    create_table :interview_invitations do |t|
      t.integer :interview_id
      t.integer :candidate_id
      t.integer :user_id
      t.text :body 
      t.string :token
      t.string :status
      t.string :subject
      t.string :title
      t.string :location
      t.string :kind
      t.timestamps
    end
  end
end
