class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :city, :string
    add_column :users, :phone, :string
    add_column :users, :linked_in, :string
    add_column :users, :website, :string
    add_column :users, :tag_line, :string
  end
end
