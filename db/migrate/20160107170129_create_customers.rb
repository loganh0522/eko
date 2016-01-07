class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :company_id, :stripe_id
      t.string :plan
      t.timestamps
    end
  end
end
