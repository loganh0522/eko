class ChangeNameOfRecipientIdToPoly < ActiveRecord::Migration
  def change
    remove_column :messages, :recipient_type
    remove_column :messages, :recipient_id
    add_column :messages, :messageable_type, :string
    add_column :messages, :messageable_id, :integer
  end
end
