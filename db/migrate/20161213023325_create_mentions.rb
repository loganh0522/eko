class CreateMentions < ActiveRecord::Migration
  def change
    create_table :mentions do |t|
      t.integer :user_id
      t.integer :mentioned_id
      t.integer :comment_id
    end
  end
end
