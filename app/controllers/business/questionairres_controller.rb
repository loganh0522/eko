class Business::QuestionairresController < ApplicationController 
  filter_access_to :all
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :has_a_questionairre, only: [:new, :create]
  before_filter :trial_over
  before_filter :company_deactivated?
  

  def index 
    @job = Job.find(params[:job_id])
    @questionairre = Questionairre.where(job_id: @job.id).first
    @scorecard = @job.scorecard
    @question = Question.new
    @questions = @questionairre.questions
  end
  
  def new
    @job = Job.find(params[:job_id])
    @questionairre = Questionairre.new
    @scorecard = @job.scorecard
  end 

  def create 
    @job = Job.find(params[:job_id])
    @questionairre = Questionairre.new(q_params)
  end

  def edit 
    @job = Job.find(params[:job_id])
    @questionairre = Questionairre.where(job_id: @job.id).first
    @scorecard = @job.scorecard
  end

  def update
    @job = Job.find(params[:job_id])
    @questionairre = Questionairre.where(job_id: @job.id).first
    
    if @questionairre.update_attributes(q_params)
      flash[:success] = "Your application form has been updated"
      redirect_to edit_business_job_questionairre_path(@job.id, @questionairre.id)
    else
      flash[:error] = "Something went wrong"
      render :edit
    end
  end

  private

  def q_params 
    params.require(:questionairre).permit(:job_id)
  end
end