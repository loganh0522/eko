class AddColumnUserIdToUserCert < ActiveRecord::Migration
  def change
    add_column :user_certifications, :user_id, :integer
  end
end
