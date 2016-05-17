class CreateMessages < ActiveRecord::Migration
  def change
    create_table :sent_messages do |t|
      t.text :body
      t.string :subject
      t.integer :application_id, :user_id

    end
  end
end
