class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.integer :subsidiary_id 
      t.integer :location_id
      t.integer :company_id
      t.string :name
      t.string :description
      t.string :image

      t.timestamps
    end

    add_column :jobs, :department_id, :integer
    add_column :jobs, :location_id, :integer
    add_column :jobs, :subsidiary_id, :integer 
  end
end
