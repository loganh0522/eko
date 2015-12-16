class AddColumnToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :company_id, :integer
    add_column :invitations, :subsidiary_id, :integer
    add_column :invitations, :location_id, :integer
  end
end
