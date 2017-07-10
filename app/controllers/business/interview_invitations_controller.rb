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
    @candidates = params[:candidates_ids].split(',')
    @times = params[:interview_invitation][:interview_times_attributes]
    @users = params[:users_ids].split(',')
    
    @interview_invite = InterviewInvitation.new(interview_invitation_params.merge!(status: "pending"))
    if @interview_invite.save
      @candidates.each do |id|
        @candidate = Candidate.find(id)
        InvitedCandidate.create(candidate_id: @candidate.id, interview_invitation_id: @interview_invite.id)
      end

      @times = @interview_invite.interview_times
      @users.each do |id| 
        @user = User.find(id)
        @token = @user.outlook_token.access_token
        @email = @user.email         
        @times.each do |time| 
          date = time.date
          time = time.time
          endTime = time.chop[0..-5] + "30:00"
          @dateTime = date + "T" + time
          @endTime = date + "T" + endTime
          OutlookWrapper::Calendar.create_event(@token, @email, @dateTime, @endTime)
        end
      end
    end

    respond_to do |format|  
      format.js
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

  def interview_invitation_params
    params.require(:interview_invitation).permit(:title, :notes, :location, :kind, :job_id, :company_id,
      interview_times_attributes: [:id, :time, :date, :_destroy],
      invited_candidates_attributes: [:id, :candidate_id])
  end

end