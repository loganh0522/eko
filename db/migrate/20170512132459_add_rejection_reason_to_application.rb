class AddRejectionReasonToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :rejection_reason, :string
  end
end
