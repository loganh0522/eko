class AddColumnToInterviewsSendMeetingRequest < ActiveRecord::Migration
  def change
    add_column :interviews, :send_request, :boolean
    
  end
end
