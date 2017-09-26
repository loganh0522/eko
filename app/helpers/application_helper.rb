module ApplicationHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id

    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end

    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", ""), :add_field => 'add_field'}, style: "display:#{name == "Add Answer" ? "none" : ""}" )
  end

  def link_to_add_to_cart(name, f, association, params)   
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    board = PremiumBoard.find(params)
    
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder, board: board)
    end

    link_to(name, '#', class: "add_to_cart btn submit-button", data: {id: id, fields: fields.gsub("\n", ""), :board => board.name}, style: "display:#{name == "Add Answer" ? "none" : ""}" )
  end

  # def social_links(user)
  #   user.social_links.each do |link|
  #     link_to ("#", link.url, class: 'fa fa-linkedin fa-stack-1x', :target => "_blank")
  #   end
  # end

  def sortable(action, params)
    title ||= action.titleize

    if request.query_parameters[params.first[0].to_s].present?
      request.query_parameters[params.first[0].to_s].push(params.first[1][0])
      link_to title, request.query_parameters
    else
      link_to title, request.query_parameters.merge(params)
    end
  end

  def build_link(path)
    if request.query_parameters[params.first[0].to_s].present?
      request.query_parameters[params.first[0].to_s].push(params.first[1][0])
      link_to path, request.query_parameters
    else
      link_to path, request.query_parameters.merge(params)
    end
  end

  def taskable_link(task)
    if task.taskable.class == Application
      if task.taskable.candidate.manually_created?
        @name = task.taskable.candidate.full_name
      else
        @name = task.taskable.candidate.user.full_name
      end
    end

    link_to(@name, '', data: {remote: true})
  end
  
  def is_activated?(link_path)
    current_page?(link_path) ? "activated" : ""
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

  def candidate_manual(activity)
    if activity.trackable.commentable.candidate.manually_created?
      return activity.trackable.commentable.candidate.user.full_name
    else 
      activity.trackable.commentable.candidate.full_name
    end
  end

  def question_answer(question, application)
    if application.question_answers.count == 0
      return "There are currently no answers for this application"
    else
      @ans = QuestionAnswer.where(question: question, application: application).first
      
      if question.kind == 'Text' || question.kind == 'Paragraph'
        if @ans.present?
          @answer = @ans.body
        else 
          return "There are currently no answers for this application"
        end
      elsif question.kind == 'Checkbox' || question.kind == 'Multiple Choice'
        if @ans.present?
          @answer = QuestionOption.find(@ans.question_option_id).body
        else 
          return "There are currently no answers for this application"
        end
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
