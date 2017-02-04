class AddFieldsToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :education_level, :string
    add_column :jobs, :career_level, :string
    add_column :jobs, :kind, :string
  end
end
