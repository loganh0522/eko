class CreatePremiumBoards < ActiveRecord::Migration
  def change
    create_table :premium_boards do |t|
      t.string :name 
      t.integer :price
      t.string :logo
      t.string :website
      t.string :description
    end
  end
end
