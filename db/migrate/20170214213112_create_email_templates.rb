class CreateEmailTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|
      t.string :title
      t.string :subject
      t.string :body
      t.string :shared
      t.string :created_by
      t.integer :user_id
      t.integer :company_id
      t.timestamps
    end
  end
end
