class Business::CommentsController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  
  def index
    @job = Job.find(params[:job_id])
    @comment = Comment.new
    @application = Application.find(params[:application_id])
    @user = @application.applicant
    @positions = @user.work_experiences
    @comments = @application.comments
    @stage = @application.stage
    @avatar = @user.user_avatar
  end

  def create 
    @comment = Comment.new(comment_params)
    @application = Application.find(params[:application_id])
    @comments = @application.comments
    @activities = current_company.activities.where(application_id: @application.id).order('created_at DESC')
    
    respond_to do |format| 
      if @comment.save 
        track_activity @comment
      else
        flash[:error] = "Sorry something went wrong"
        redirect_to :back
      end
      format.js 
    end
  end

  def add_note_multiple 
    @job = Job.find(params[:job_id])  
    applicant_ids = params[:applicant_ids].split(',')
    
    applicant_ids.each do |id| 
      @application = Application.where(user_id: id, job_id: params[:job_id]).first
      @comment = Comment.new(body: params[:comment], user_id: current_user.id, application_id: @application.id)
      track_activity(@comment, "create")
    end
    redirect_to business_job_path(@job)
  end

  private 

  def comment_params 
    params.require(:comment).permit(:body, :user_id, :application_id)
  end
end