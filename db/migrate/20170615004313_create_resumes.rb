class CreateResumes < ActiveRecord::Migration
  def change
    create_table :resumes do |t|
      t.string :name
      t.string :attachment
      t.integer :candidate_id
      t.integer :application_id
      t.timestamps
    end
  end
end
