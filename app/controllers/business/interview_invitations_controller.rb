class Business::InterviewInvitationsController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def index
    @interview_invitations = current_company.interview_invitations

    respond_to do |format|
      format.html
      format.js
    end
  end

  def job_invitations
    @job = Job.find(params[:job_id])
    @interview_invitations = current_company.interview_invitations
  end

  def new
    @invitation = InterviewInvitation.new

    respond_to do |format| 
      format.js 
    end 
  end

  def create 
    @candidate_ids = params[:interview_invitation][:candidate_ids].split(',')  
    @user_ids = params[:interview_invitation][:user_ids].split(',')  
    @interview_invite = InterviewInvitation.new(interview_invitation_params.merge!(candidate_ids: @candidate_ids, user_ids: @user_ids))

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

  private

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
    AppMailer.send_interview_invitation(@token, @message, @subject, @job, email, current_company).deliver_now
    # end
  end

  def schedule_in_calendar(interview_invite)
    @users = interview_invite.users
    
    @users.each do |user| 
      if user.outlook_token.present?
        @times = interview_invite.interview_times
        @email = user.email          
        
        @times.each do |time| 
          date = time.date
          dateTime = DateTime.parse(time.time).strftime("%H:%M:%S")
          endTime = dateTime.chop[0..-5] + "30:00"
          @dateTime = date + "T" + dateTime
          @endTime = date + "T" + endTime

          OutlookWrapper::Calendar.create_event(user, @dateTime, @endTime, time)
        end
      end
    end
  end

  def set_interview_invitation
    @interview_invite = InterviewInvitations.find_by(token: params[:id])
  end

  def interview_invitation_params
    params.require(:interview_invitation).permit(:title, :notes, :location, 
      :kind, :job_id, 
      :subject, :message, :user_id, :company_id,
      candidate_ids: [], 
      user_ids: [],
      interview_times_attributes: [:id, :time, :date, :_destroy])
  end
end