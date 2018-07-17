class Business::QuestionairresController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?


  def index
    if params[:application_id].present?
      @application = Application.find(params[:application_id])
      @candidate = @application.candidate
      @questionairres = @application.questionairres
    else
      @candidate = Candidate.find(params[:candidate_id]) 
      @questionairres = @candidate.questionairres
    end
    
    respond_to do |format|
      format.js
    end 
  end
  
  def new
    @job = Job.find(params[:job_id])
    @question = Question.new

    respond_to do |format|
      format.js 
    end
  end

  def create
    @job = Job.find(params[:job_id])
    @question = Question.new(q_params.merge(position: new_stage_position(@job)))
    
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

  def sort
    @job = Job.find(params[:job_id])

    params[:question].each_with_index do |id, index|
      Question.update(id, {position: index + 1})
    end

    render nothing: true
  end

  private

  def new_stage_position(job)
    job.questions.count + 1
  end

  def q_params 
    params.require(:question).permit(:id, :job_id, :body, :required, :kind, :position,
      question_options_attributes: [:id, :body, :_destroy])
  end

  def render_errors(question)
    @errors = []
    question.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end
end