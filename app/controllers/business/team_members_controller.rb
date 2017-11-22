class Business::TeamMembersController < ApplicationController
  layout "business"
  # filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def create
    @member = TeamMember.create(member_params)
    @section = JobBoardRow.new
    # @job_board_header = @background.job_board_header if @background.job_board_header_id.present?
    respond_to do |format| 
      format.js
    end
  end

  def edit 
    @member = TeamMember.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @member = TeamMember.find(params[:id])
    @member.update(member_params)

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @member = TeamMember.find(params[:id])
    @member.destroy

    @job_board_header = @member.job_board_header

    respond_to do |format|
      format.js
    end
  end

  private

  def member_params
    params.require(:team_member).permit(:file, :job_board_row_id)
  end
end