class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :token 
    end
  end
end
