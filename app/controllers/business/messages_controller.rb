class Business::MessagesController < ApplicationController 
  
  def index 
    @job = Job.find(params[:job_id])
    @application = Application.find(params[:application_id])
    @user = @application.applicant
    @messages = @application.messages
    @stage = @application.stage
    @comment = Comment.new
  end

  def create 
    @messages = Message.new(message_params)
  end

  def send_multiple_messages 
    @job = Job.find(params[:job_id])
    applicant_ids = params[:applicant_ids].split(',')

    applicant_ids.each do |id| 
      @application = Application.where(user_id: id, job_id: params[:job_id]).first
      @message = Message.create(body: params[:body], application_id: @application.id, user_id: current_user.id)
      @recipient = User.find(id)

      AppMailer.send_applicant_message(@message, @job, @recipient, current_company).deliver
    end
    redirect_to business_job_path(@job)
  end
  
end