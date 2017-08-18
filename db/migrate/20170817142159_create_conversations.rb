class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :company_id 
      t.integer :user_id
      t.integer :candidate_id
      t.timestamps
    end
  end
end
