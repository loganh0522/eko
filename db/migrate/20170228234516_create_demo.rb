class CreateDemo < ActiveRecord::Migration
  def change
    create_table :demos do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :message
      t.string :company
      t.string :company_size
      t.string :company_website
      t.string :demo
    end
  end
end
