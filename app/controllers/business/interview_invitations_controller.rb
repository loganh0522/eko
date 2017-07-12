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
    @invitation = InterviewInvitation.new

    respond_to do |format| 
      format.js 
    end 
  end

  def create    
    @interview_invite = InterviewInvitation.new(interview_invitation_params)
    respond_to do |format|
      if @interview_invite.save
        send_invitations(@interview_invite)
        schedule_in_calendar(@interview_invite)
        format.js
      else 
        @errors = []
        @interview_invite.errors.messages.each do |error| 
          @errors.append([error[0].to_s, error[1][0]])
        end
        
        format.js
      end 
    end
  end

  def show 
    @interview_invite = InterviewInvitation.find(params[:id])
  end

  private

  def assigned_to(task)
    user_ids = params[:interview][:user_ids].split(',')
    user_ids.each do |id| 
      AssignedUser.create(assignable_type: "Interview", assignable_id: task.id, user_id: id )
    end
  end

  def send_invitations(interview_invite)
    @candidates = @interview_invite.candidates    
    @candidates.each do |candidate|
      if candidate.manually_created == true
        @email = candidate.email
      else 
        @email = candidate.user.email
      end  
      send_invitation_email(interview_invite, candidate, @email) 
    end  
  end

  def send_invitation_email(interview_invite, candidate, email)
    @job = interview_invite.job if @interview_invite.job.present?
    @message = interview_invite.message
    @subject = interview_invite.subject
    @token = interview_invite.token

    # if current_user.outlook_token.present? 
    #   @email = Mail.new(to: @recipient.email, from: current_user.email, subject: params[:message][:subject], body: params[:body], content_type: "text/html")
    #   GoogleWrapper::Gmail.send_message(@email, current_user, message)
    # else 
    AppMailer.send_interview_invitation(@token, @message, @subject, @job, email, current_company).deliver
    # end
  end

  def schedule_in_calendar(interview_invite)
    @users = @interview_invite.users
    @users.each do |user| 
      @times = @interview_invite.interview_times
      # @token = user.outlook_token.access_token
      @email = user.email          
      
      @times.each do |time| 
        date = time.date
        time = time.time
        endTime = time.chop[0..-5] + "30:00"
        @dateTime = date + "T" + time
        @endTime = date + "T" + endTime
        OutlookWrapper::Calendar.create_event(user, @email, @dateTime, @endTime)
      end
    end
  end

  def set_interview_invitation
    @interview_invite = InterviewInvitations.find_by(token: params[:id])
  end

  def interview_invitation_params
    params.require(:interview_invitation).permit(:title, :notes, :location, :kind, :job_id, 
      :candidate_ids, :user_ids, :subject, :message, :user_id, :company_id,
      interview_times_attributes: [:id, :time, :date, :_destroy])
  end

end