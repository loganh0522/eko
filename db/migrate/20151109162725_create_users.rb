class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, :first_name, :last_name 
      t.string :password_digest
      t.integer :company_id
    end
  end
end
