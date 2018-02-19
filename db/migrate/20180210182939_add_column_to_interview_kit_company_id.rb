class AddColumnToInterviewKitCompanyId < ActiveRecord::Migration
  def change
    add_column :interview_kits, :company_id, :integer
    add_column :interview_kits, :title, :integer
  end
end
