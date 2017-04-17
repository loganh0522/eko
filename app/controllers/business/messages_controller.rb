class Business::MessagesController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def create 
    @job = Job.find(params[:job_id])
    @application = Application.find(params[:application_id])
    @user = @application.applicant
    @message = Message.create(body: params[:body], subject: params[:message][:subject], application_id: @application.id, user_id: current_user.id)
    


    @messages = @application.messages
    @recipient = @application.applicant
    @token = @application.token
    @activities = current_company.activities.where(application_id: @application.id).order('created_at DESC')

    if @current_user.google_token.present? 
      @email = Mail.new(to: @recipient.email, from: current_user.email, subject: params[:message][:subject], body: params[:body], content_type: "text/html")
      GoogleWrapper::Gmail.send_message(@email, current_user)
    else 
      AppMailer.send_applicant_message(@token, @message, @job, @recipient, current_company).deliver
      track_activity(@message)
    end

    respond_to do |format| 
      @application = Application.find(params[:application_id])
      format.js 
    end
  end

  def get_thread
    service.get_user_thread('me', "15b4e83fccf315c4").messages.first.payload.body
  end

  def send_multiple_messages    
    applicant_ids = params[:applicant_ids].split(',')

    applicant_ids.each do |id| 
      @application = Application.find(id)
      @job = Job.find(@application.job_id)
      @message = Message.create(body: params[:body], application_id: @application.id, user_id: current_user.id)
      @recipient = @application.applicant
      @token = @application.token
      AppMailer.send_applicant_message(@token, @message, @job, @recipient, current_company).deliver
    end
    track_activity(@message, "create")
    redirect_to :back
  end
end