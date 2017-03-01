class CreateContactUs < ActiveRecord::Migration
  def change
    create_table :contact_messages do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :message
      t.string :company
    end
  end
end
