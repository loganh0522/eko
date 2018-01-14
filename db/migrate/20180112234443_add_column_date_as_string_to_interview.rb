class AddColumnDateAsStringToInterview < ActiveRecord::Migration
  def change
    add_column :interviews, :date, :string
  end
end
