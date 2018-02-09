class Business::InterviewInvitationsController < ApplicationController
  layout "business"
  load_and_authorize_resource only: [:new, :create, :edit, :update, :index, :show, :destroy]

  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def index
    @interview_invitations = current_company.interview_invitations.accessible_by(current_ability)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def job_invitations
    @job = Job.find(params[:job_id])
    @interview_invitations = current_company.interview_invitations.accessible_by(current_ability)
  end

  def new
    @candidate = Candidate.find(params[:candidate_id]) if params[:candidate_id].present?
    @job = Job.find(params[:job]) if params[:job].present?
    @invitation = InterviewInvitation.new
    @users = current_company.users 
    @candidates = current_company.candidates

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
        schedule_room(@interview_invite) if params[:interview_invitation][:room_id].present? 
      else 
        render_errors(@interview_invite)
      end 
      format.js
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
    @message = interview_invite.message +  "<p> <a href='www.talentwiz.ca/schedule_interview/#{interview_invite.token}'> Schedule Interview Link </a> </p>"
    @subject = interview_invite.subject
    @token = interview_invite.token

    if current_user.outlook_token.present? || current_user.google_token.present?   
      if candidate.conversation.present? 
        @message = candidate.messages.create(body: @message, subject: @subject, user: current_user, conversation_id: candidate.conversation.id)
      else 
        @conversation = Conversation.create(candidate_id: candidate.id, company_id: current_company.id)   
        @message = candidate.messages.create(body: @message, subject: @subject, user: current_user, conversation_id: @conversation.id)
      end   
    else  
      AppMailer.send_interview_invitation(@token, @message, @subject, @job, email, current_company).deliver_now
    end
  end

  def schedule_in_calendar(event)
    @users = event.users
    
    @users.each do |user| 
      if user.outlook_token.present?
        @times = event.interview_times
        @email = user.email          
        
        @times.each do |time| 
          @startTime = time.start_time.strftime("%Y-%m-%dT%H:%M:%S")
          @endTime = time.end_time.strftime("%Y-%m-%dT%H:%M:%S")
          OutlookWrapper::Calendar.create_event(event, user, @startTime, @endTime, time)
        end
      elsif user.google_token.present? 
        @times = event.interview_times
        @email = user.email   
        @times.each do |time| 
          @startTime = time.start_time.strftime("%Y-%m-%dT%H:%M:%S")
          @endTime = time.end_time.strftime("%Y-%m-%dT%H:%M:%S")
          GoogleWrapper::Calendar.create_event(event, current_user, @startTime, @endTime, time)
        end
      end
    end
  end

  def schedule_room(interview_invite)
    @room = Room.find(params[:interview_invitation][:room_id])
    
    if @room.outlook_token.present?
      @times = interview_invite.interview_times
      @email = @room.email          
      
      @times.each do |time| 
        @startTime = time.start_time.strftime("%Y-%m-%dT%H:%M:%S")
        @endTime = time.end_time.strftime("%Y-%m-%dT%H:%M:%S")
        OutlookWrapper::Calendar.create_event(interview_invite, @room, @startTime, @endTime, time)
      end
    elsif user.google_token.present? 
    end
  end

  def set_interview_invitation
    @interview_invite = InterviewInvitations.find_by(token: params[:id])
  end

  def interview_invitation_params
    params.require(:interview_invitation).permit(:title, :location, 
      :kind, :job_id, :subject, :message, :body,
      :user_ids, :candidate_ids, :user_id, :company_id, :room_id,
      interview_times_attributes: [:id, :start_time, :end_time, :_destroy])
  end

  def render_errors(interview)
    @errors = []
    interview.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end