class TeamMember < ActiveRecord::Base
  belongs_to :job_board_row
  mount_uploader :file, TeamMembersUploader
end