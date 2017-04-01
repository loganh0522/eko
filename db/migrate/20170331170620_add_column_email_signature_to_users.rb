class AddColumnEmailSignatureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_signature, :string
  end
end
