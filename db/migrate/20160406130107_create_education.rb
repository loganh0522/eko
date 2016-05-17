class CreateEducation < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.integer :user_id
      t.string :start_month, :start_year, :end_month, :end_year
      t.string :school
      t.string :degree
      t.text :description
    end
  end
end
