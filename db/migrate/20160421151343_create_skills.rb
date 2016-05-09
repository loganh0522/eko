class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.integer :name
    end
  end
end
