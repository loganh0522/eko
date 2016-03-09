class Business::CommentsController < ApplicationController 
  
  def index
    @job = Job.find(params[:job_id])
    @comment = Comment.new
    @application = Application.find(params[:application_id])
    @user = @application.applicant
    @positions = @user.work_experiences
    @comments = @application.comments
    @stage = @application.stage
  end

  def create 
    @comment = Comment.new(comment_params)

    if @comment.save 
      redirect_to :back
    else
      flash[:error] = "Sorry something went wrong"
      redirect_to :back
    end
  end

  def add_note_multiple 
    @job = Job.find(params[:job_id])  
    applicant_ids = params[:applicant_ids].split(',')
    
    applicant_ids.each do |id| 
      @application = Application.where(user_id: id, job_id: params[:job_id]).first
      Comment.create(body: params[:comment], user_id: current_user.id, application_id: @application.id)
    end
    redirect_to business_job_path(@job)
  end

  private 

  def comment_params 
    params.require(:comment).permit(:body, :user_id, :application_id)
  end
end