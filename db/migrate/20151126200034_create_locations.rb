class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :number
      t.integer :company_id
      t.integer :subsidiary_id
    end
  end
end
