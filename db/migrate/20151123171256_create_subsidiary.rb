class CreateSubsidiary < ActiveRecord::Migration
  def change
    create_table :subsidiaries do |t|
      t.string :name 
      t.integer :company_id
    end
  end
end
