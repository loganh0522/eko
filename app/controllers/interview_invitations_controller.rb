class InterviewInvitationsController < ApplicationController 


  def show 
    @invitation = InterviewInvitation.find(params[:id])
    @times = @invitation.times
    
  end
end