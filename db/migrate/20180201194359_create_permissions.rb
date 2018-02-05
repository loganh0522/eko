class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :name
      t.integer :company_id

      t.boolean :create_job, default: true
      t.boolean :view_all_jobs, default: true
      t.boolean :edit_job, default: true
      t.boolean :add_team_members, default: true
      

      t.boolean :create_candidates, default: true
      t.boolean :edit_candidates, default: true
      t.boolean :view_all_candidates, default: true
      t.boolean :move_candidates, default: true

      t.boolean :create_tasks, default: true
      t.boolean :view_all_tasks, default: true
      t.boolean :assign_tasks, default: true

      t.boolean :send_messages, default: true
      t.boolean :view_all_messages, default: true
      t.boolean :view_section_messages, default: true

      t.boolean :create_event, default: true
      t.boolean :view_events, default: true
      t.boolean :send_event_invitation
      t.boolean :view_all_events, default: true

      t.boolean :view_analytics, default: true
      t.boolean :edit_career_portal, default: true
      t.boolean :access_settings, default: true
    end
  end
end
