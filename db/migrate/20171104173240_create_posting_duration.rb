class CreatePostingDuration < ActiveRecord::Migration
  def change
    create_table :posting_durations do |t|
      t.integer :premium_board_id
      t.string :duration
      t.string :kind
      t.integer :price
      t.decimal :real_price
      t.string :name
    end
  end
end
