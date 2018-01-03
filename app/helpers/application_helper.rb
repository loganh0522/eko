module ApplicationHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id

    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end

    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", ""), :add_field => 'add_field'}, style: "display:#{name == "Add Answer" ? "none" : ""}" )
  end

  def link_to_add_to_cart(name, f, association, params, duration)

    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    board = PremiumBoard.find(params)
    price = PostingDuration.find(duration)
    
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder, board: board, price: price)
    end

    link_to(name, '#', class: "add_to_cart btn job-seeker-btn", data: {id: id, fields: fields.gsub("\n", ""), :board => board.name}, style: "display:#{name == "Add Answer" ? "none" : ""}" )
  end

  
  def show_errors(object, field_name)
    if object.errors.any?
      if !object.errors.messages[field_name].blank?
        object.errors.messages[field_name].join(", ")
      end
    end
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

  def question_answer(question, candidate, job)
    if candidate.question_answers.count == 0
      return "There are currently no answers for this application"
    else
      if question.kind == 'Text' || question.kind == 'Paragraph'
        @answers = QuestionAnswer.where(question: question, candidate: candidate, job_id: job.id).first 
        if @answers.present?
          @answer = @answers.body
        else 
          return "There are currently no answers for this application"
        end
      elsif question.kind == 'Multiple Choice'
        @answers = []
        question.question_answers.each do |answer| 
          @answers.push(answer.question_option_id)
        end
        content_tag(:ui, :class => "multi-answer") do 
          question.question_options.each do |option| 
            if @answers.include?(option.id)
              concat content_tag(:li, option.body, :class => "bold")
            else
              concat content_tag(:li, option.body)
            end
          end 
        end 
      elsif question.kind == 'Checkbox'
        @answers = []
        question.question_answers.each do |answer| 
          @answers.push(answer.question_option_id)
        end
        content_tag(:ui, :class => "multi-answer") do 
          question.question_options.each do |option| 
            if @answers.include?(option.id)
              concat content_tag(:li, option.body, :class => "bold")
            else
              concat content_tag(:li, option.body)
            end
          end 
        end 
      end
    end
  end

  def current_user_application_rating(application)
    if current_user.ratings.where(application_id: application.id).present?
      @rating = current_user.ratings.where(application_id: 1).first.score
    end
  end
end
