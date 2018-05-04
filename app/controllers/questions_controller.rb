class QuestionsController < ApplicationController 
  

  def index 
    @job = Job.find(params[:job_id])
    @questions = @job.questions
    json(@questions)
    render json: @questions
  end

  private 

  def json(questions)
    @questions = []

    questions.each do |q| 
      @question = {id: q.id, question: q.body, required: q.required}

      if q.kind == 'Multiselect'
        @question.merge!(type: "multiselect")
      elsif q.kind == 'Select (One)'
        @question.merge!(type: "select")
      elsif q.kind == 'File'
        @question.merge!(type: "file")
      elsif q.kind == 'Text (Short Answer)'
        @question.merge!(type: "text")
      else
        @question.merge!(type: "textarea")
      end

      if q.question_options.present?
        @options = []
        q.question_options.each do |option|
          @options << {value: option.id, label: option.body} 
        end
        @question.merge!(options: @options)
      end
      @questions << @question
    end

    return @questions
  end
end