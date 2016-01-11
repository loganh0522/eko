class CreateHiringTeam < ActiveRecord::Migration
  def change
    create_table :hiring_members do |t|
      t.timestamps
    end
  end
end
