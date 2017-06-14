module ApplicationHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", ""), :add_field => 'add_field'}, style: "display:#{name == "Add Answer" ? "none" : ""}" )
  end

  def is_active?(link_path)
    current_page?(link_path) ? "active" : ""
  end

  def is_current_stage?(stage, application)
    if application.stage.id == stage.id
      return true
    else
      return false
    end
  end

  def question_answer(question, application)
    if application.question_answers.count == 0
      return "There are currently no answers for this application"
    else
      @ans = QuestionAnswer.where(question: question, application: application).first
      if question.kind == 'Text' || question.kind == 'Paragraph'
        @answer = @ans.body
      elsif question.kind == 'Checkbox' || question.kind == 'Multiple Choice'
        @answer = QuestionOption.find(@ans.question_option_id).body
      end
      return @answer
    end
  end


  def current_user_application_rating(application)
    if current_user.ratings.where(application_id: application.id).present?
      @rating = current_user.ratings.where(application_id: 1).first.score
    end
  end

  
end
