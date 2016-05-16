class AddTokenToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :token, :string
  end
end
