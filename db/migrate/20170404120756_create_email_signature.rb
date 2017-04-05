class CreateEmailSignature < ActiveRecord::Migration
  def change
    create_table :email_signatures do |t|
      t.string :signature
      t.integer :user_id
      t.timestamps
    end
  end
end
