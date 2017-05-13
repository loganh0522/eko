class CreateRejectionReasons < ActiveRecord::Migration
  def change
    create_table :rejection_reasons do |t|
      t.integer :company_id
      t.integer :application_id
      t.string :body
      t.timestamps
    end
  end
end
