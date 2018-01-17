class InterviewsController < ApplicationController 
  def new
    @invitation = InterviewInvitation.find_by(token: params[:token])
    
    if @invitation.present?
      @interview = Interview.new  
      @company = @invitation.company
      @times = @invitation.interview_times
    else
      redirect_to 
    end
  end

  def create
    @time = InterviewTime.find_by(id: params[:time])  
    
    if @time.present?
      @invite =  @time.interview_invitation
      @candidate = @invite.candidates.where(email: (params[:email]).downcase).first  
      @events = @time.event_ids
      
      @interview = Interview.new(interview_params.merge!(
        title: @invite.title, kind: @invite.kind, location: @invite.location,
        users: @invite.users, candidate_id: @candidate.id, job: @invite.job,
        start_time: @time.start_time , end_time: @time.end_time,
        etime: 'n/a', stime: 'n/a', date: 'n/a'))
      
      if @interview.save
        update_user_calendar(@time, @candidate)  
        InvitedCandidate.where(candidate_id: @candidate.id, interview_invitation_id: @invite.id).first.destroy
        @events.each do |event|
          event.update_attributes(interview_id: @interview.id, interview_time_id: nil)
        end
        @time.destroy
        destroy_user_events

        redirect_to booked_path(@interview)
      else
        render :new
        @invitation = InterviewInvitation.where(token: params[:token]).first
        @company = @invitation.company
        @times = @invitation.interview_times
      end
    else 
      flash[:danger] = "Uh-oh, this time has already been booked. Please choose a different time."
      @interview = Interview.new
      @invitation = InterviewInvitation.where(token: params[:token]).first
      @company = @invitation.company
      @times = @invitation.interview_times
      render :new
    end
  end

  def show
    @interview = Interview.find(params[:id])
  end

  private 

  def update_user_calendar(time, candidate)
    @events = @time.event_ids
    @candidate = candidate 
   
    @events.each do |event| 
      if event.user_id == nil 
        @user = event.room
      else
        @user = event.user
      end
      
      if @user.outlook_token.present?    
        OutlookWrapper::Calendar.update_event(@user, event, candidate)
      elsif @user.google_token.present?
        GoogleWrapper::Calendar.update_event(@user, event, candidate)
      end
    end
  end

  def destroy_user_events
    if @invite.candidates.count == 0 
      @invite.interview_times.each do |time|
        time.event_ids.each do |event|
          if event.user_id == nil 
            @user = event.room
          else
            @user = event.user
          end
          if @user.outlook_token.present?    
            OutlookWrapper::Calendar.destroy_event(@user, event)
          end
        end
      end
      @invite.destroy
    end
  end

  def interview_params
    params.require(:interview).permit(:job_id,
      :company_id, :kind, :string,
      :start_time, :end_time, :location,
      users: [])
  end
end