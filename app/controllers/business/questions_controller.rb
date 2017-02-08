class Business::QuestionsController < ApplicationController
  def new
    @job = Job.find(params[:job_id])
    @questionairre = Questionairre.find(params[:questionairre_id])
    @question = Question.new
    respond_to do |format|
      format.js 
    end
  end

  def create
    @question = Question.new(q_params)
    @job = Job.find(params[:job_id])
    @questionairre = Questionairre.find(params[:questionairre_id])  
    respond_to do |format| 
      if @question.save
        @questions = @questionairre.questions
        format.js 
      else 
        flash[:danger] = "Something went wrong, please try again."
      end
    end  
  end

  def edit
    @questionairre = Questionairre.find(params[:questionairre_id])
    @question = Question.find(params[:id])
    @job = Job.find(params[:job_id])
  end

  def update
    @question = Question.find(params[:id])
    @job = Job.find(params[:job_id])
    @questionairre = Questionairre.find(params[:questionairre_id]) 
    respond_to do |format|
      if @question.update(q_params)
        @questions = @questionairre.questions
        format.js
      else
        flash[:danger] = "Sorry something went wrong"
      end
    end
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
    params.require(:question).permit(:id, :questionairre_id, :body, :required, :kind, question_options_attributes: [:id, :body, :_destroy])
  end
end