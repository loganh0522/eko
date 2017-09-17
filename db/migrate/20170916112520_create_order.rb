class CreateOrder < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :company_id
      t.integer :job_id
      t.integer :user_id
      t.string :status
      t.decimal :subtotal
      t.decimal :tax
      t.decimal :total
    end
  end
end
