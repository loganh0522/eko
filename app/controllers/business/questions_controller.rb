class Business::QuestionsController < ApplicationController
  layout "business"
  filter_access_to :all
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def index
    @job = Job.find(params[:job_id])
    @questions = @job.questions
  end
  
  def new
    @job = Job.find(params[:job_id])
    @question = Question.new

    respond_to do |format|
      format.js 
    end
  end

  def create
    @question = Question.new(q_params)
    @job = Job.find(params[:job_id])

    respond_to do |format| 
      if @question.save
        @questions = @job.questions 
      else 
        render_errors(@question)
      end
      format.js
    end  
  end

  def edit
    @question = Question.find(params[:id])
    @job = Job.find(params[:job_id])

    respond_to do |format|
      format.js 
    end
  end

  def update
    @question = Question.find(params[:id])
    @job = Job.find(params[:job_id])

    respond_to do |format|
      if @question.update(q_params)
        @questions = @job.questions
      else
        render_errors(@question)
      end
      format.js
    end
  end

  def show 
    @job = Job.find(params[:job_id])
    @questions = @job.questions
  end

  def destroy
    @question = Question.find(params[:id])  
    @question.destroy  
    
    respond_to do |format|
      format.js 
    end
  end

  private

  def q_params 
    params.require(:question).permit(:id, :job_id, :body, :required, :kind, question_options_attributes: [:id, :body, :_destroy])
  end

  def render_errors(question)
    @errors = []
    question.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end