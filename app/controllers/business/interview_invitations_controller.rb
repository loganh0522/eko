class Business::InterviewInvitationsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def index
    get_access_token
    @interview_invites = InterviewInvitation.all
    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    @interview_invitation = InterviewInvitation.new

    respond_to do |format| 
      format.js 
    end 
  end

  def create
    @interview_invite = InterviewInvitation.new(interview_params)
    
    respond_to do |format|  
      if @interview_invite.save
        format.js
      else
        flash[:danger] = "Something went wrong"
      end
    end
  end

  def show 
    @interview_invite = InterviewInvitation.find(params[:id])
  end


  def edit 
    @interview_invite = InterviewInvitations.find(params[:id])
    respond_to do |format|  
      format.js
    end
  end

  private

  def assigned_to(task)
    user_ids = params[:interview][:user_ids].split(',')
    user_ids.each do |id| 
      AssignedUser.create(assignable_type: "Interview", assignable_id: task.id, user_id: id )
    end
  end

  def send_invitation(token, message, job, recipient, current_company)
    if current_user.outlook_token.present? 
      @email = Mail.new(to: @recipient.email, from: current_user.email, subject: params[:message][:subject], body: params[:body], content_type: "text/html")
      GoogleWrapper::Gmail.send_message(@email, current_user, message)
    else 
      AppMailer.send_applicant_message(token, message, job, recipient, current_company).deliver
    end
  end

  def set_interview_invitation
    @interview_invite = InterviewInvitations.find_by(token: params[:id])
  end

  def interview_params
    params.require(:interview).permit(:title, :notes, :location, :start_time, :end_time, :date, :kind, :job_id, :candidate_id, :company_id)
  end

end