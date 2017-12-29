class CreateFreeBoards < ActiveRecord::Migration
  def change
    create_table :free_boards do |t|
      t.string :logo
      t.text :description
      t.string :name
      t.string :job_feed_name
      t.string :website
      t.timestamps
    end
  end
end
