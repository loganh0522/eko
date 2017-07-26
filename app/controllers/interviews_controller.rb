class InterviewsController < ApplicationController 
  def show 
    @interview = Interview.new

    @invitation = InterviewInvitation.where(token: params[:token]).first
    
    @job = @invitation.job if present? 
    @company = @invitation.company
    @times = @invitation.interview_times
    @users = @invitation.users
    @user_ids = []
    
    @users.each do |user|
      @user_ids.append(user.id)
    end
  end

  
  def create
    @time = InterviewTime.find(params[:time])  
    
    if @time.present?
      @invite =  @time.interview_invitation
      @candidate = @invite.candidates.where(email: (params[:email]).downcase).first  
      @events = @time.event_ids
      @user_ids = params[:interview][:user_ids].split(' ') 
      @job = @invite.job if @invite.job.present?
      
      @interview = Interview.new(interview_params.merge!(
        user_ids: @user_ids,
        candidate_id: @candidate.id,
        job: @job,
        start_time: @time.time , date: @time.date))
      
      if @interview.save
        update_user_calendar(@time, @candidate)  
        InvitedCandidate.where(candidate_id: @candidate.id, interview_invitation_id: @invite.id).first.destroy
        
        @events.each do |event|
          event.update_attributes(interview_id: @interview.id, interview_time_id: nil)
        end

        @time.destroy

        if @invite.candidates.count == 0 
          @invite.destroy
        end
      else
        respond_to do |format|
          format.js
        end
      end
    else 
      respond_to do |format|
        flash[:danger] = "Uh-oh, this time has already been booked. Please choose a different time."
        format.js
      end
    end
  end

  private 

  def update_user_calendar(time, candidate)
    @events = @time.event_ids
    @candidate = candidate 
   
    @events.each do |event| 
      @user = event.user
      
      if @user.outlook_token.present?    
        OutlookWrapper::Calendar.update_event(@user, event, candidate)
      end
    end
  end

  def interview_params
    params.require(:interview).permit(:job_id,
      :company_id, :kind, :string, 
      :start_time, :end_time, :location,
      user_ids: [])
  end
end