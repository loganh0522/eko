class AddUserIdToJobCountries < ActiveRecord::Migration
  def change
    add_column :job_countries, :user_id, :integer
  end
end
