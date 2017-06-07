class CreateApplicationEmails < ActiveRecord::Migration
  def change
    create_table :application_emails do |t|
      t.text :body
      t.integer :company_id
      t.integer :job_id
      t.string :subject
      t.timestamps
    end
  end
end
