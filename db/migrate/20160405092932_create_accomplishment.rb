class CreateAccomplishment < ActiveRecord::Migration
  def change
    create_table :accomplishments do |t|
      t.integer :work_experience_id
      t.text :body
    end
  end
end
