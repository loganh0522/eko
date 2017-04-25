class CreateApplicantContactDetails < ActiveRecord::Migration
  def change
    create_table :applicant_contact_details do |t|
      t.integer :application_id 
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :location
      t.string :city
      t.string :province
      t.string :country
      t.timestamps
    end
  end
end
