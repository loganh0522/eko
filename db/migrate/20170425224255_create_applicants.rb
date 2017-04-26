class CreateApplicants < ActiveRecord::Migration
  def change
    create_table :applicants do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :location
      t.boolean :manually_created
      t.string :source
      t.string :token
      t.integer :company_id
      t.integer :user_id

      t.timestamps
    end
  end
end
