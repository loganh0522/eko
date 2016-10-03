class Business::MessagesController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :company_deactivated?
  
  def index 
    @job = Job.find(params[:job_id])
    @application = Application.find(params[:application_id])
    @user = @application.applicant
    @avatar = @user.user_avatar
    @messages = @application.messages
    @stage = @application.stage
    @comment = Comment.new
    @message = Message.new
  end

  def create 
    @job = Job.find(params[:job_id])
    
    @application = Application.find(params[:application_id])
    @user = @application.applicant
    @message = Message.create(body: params[:message][:body], application_id: @application.id, user_id: current_user.id)
    @messages = @application.messages
    @recipient = @application.applicant
    @token = @application.token
    @activities = current_company.activities.where(application_id: @application.id).order('created_at DESC')

    AppMailer.send_applicant_message(@token, @message, @job, @recipient, current_company).deliver
    track_activity(@message)

    respond_to do |format| 
      format.js 
    end
  end

  def send_messages 
    @job = Job.find(params[:job_id])
    @application = Application.where(user_id: id, job_id: params[:job_id]).first
    @message = Message.create(body: params[:message][:body], application_id: @application.id, user_id: current_user.id)
    @recipient = User.find()
    @token = @application.token

    AppMailer.send_applicant_message(@token, @message, @job, @recipient, current_company).deliver
    track_activity(@message, action = "create")

    redirect_to business_job_path(@job)
  end

  def send_multiple_messages 
    @job = Job.find(params[:job_id])
    applicant_ids = params[:applicant_ids].split(',')

    applicant_ids.each do |id| 
      @application = Application.where(user_id: id, job_id: params[:job_id]).first
      @message = Message.create(body: params[:body], application_id: @application.id, user_id: current_user.id)
      @recipient = User.find(id)
      @token = @application.token

      AppMailer.send_applicant_message(@token, @message, @job, @recipient, current_company).deliver
      track_activity(@message, action = "create")
    end
    redirect_to business_job_path(@job)
  end


  
end