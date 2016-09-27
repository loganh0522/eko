class ChangeColumnInSkills < ActiveRecord::Migration
  def change
    change_column :skills, :name, :string
  end
end
