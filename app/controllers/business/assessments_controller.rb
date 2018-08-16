class Business::AssessmentsController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index   
    if params[:candidate_id].present?
      @candidate = Candidate.find(params[:candidate_id])
      @assessments = @candidate.assessments
    elsif params[:application_id].present?
      @application = Application.find(params[:application_id])
      @assessments = @application.assessments
    end 
  end

  def new_assessment
    @application = Application.find(params[:application_id]) if params[:application_id].present?
    
    @candidate = Candidate.find(params[:candidate_id]) if params[:candidate_id].present?

    if params[:kind].present? 
      @templates = current_company.interview_kit_templates
    else 
      @templates = current_company.scorecard_templates
    end

    respond_to do |format|
      format.js
    end
  end

  def new
    @assessment = Assessment.new
    @scorecard = Scorecard.new
    @users = current_company.users
    
    if params[:application_id].present?
      @application = Application.find(params[:application_id]) 
      @candidate = @application.candidate
    else
      @candidate = Candidate.find(params[:candidate_id]) 
    end

    respond_to do |format|
      format.js
    end
  end

  def create_from_template
    # @user_ids = params[:assessment][:user_ids].split(',') if params[:assessment][:user_ids].present?

    if params[:kind] == "kit"
      @template = InterviewKitTemplate.find(params[:template])
      create_interview_kit(@template)
    else 
      @template = ScorecardTemplate.find(params[:template])
      create_scorecard(@template)
    end
    respond_to do |format|
      format.js
    end
  end

  def create 
    @user_ids = params[:assessment][:user_ids].split(',') if params[:assessment][:user_ids].present?
    @assessment = Assessment.new(assessment_params.merge!(user_ids: @user_ids)) 

    respond_to do |format| 
      if @assessment.save 
        format.js
      else
        render_errors(@assessment)
        format.js
      end
    end
  end

  def edit
    @assessment = Assessment.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @assessment = Assessment.find(params[:id])

    respond_to do |format|
      if @assessment.update(stage_params)

        format.js
      else
        render_errors(@assessment)
        format.js
      end 
    end
  end

  def destroy
    @assessment = Assessment.find(params[:id])
    @assessment.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def assessment_params
    params.require(:assessment).permit(:name, :candidate_id, :application_id, :kind, :preperation,
      scorecard_attributes: [:id, :name,
        section_options_attributes: [:id, :body, :quality_answer, :required, :_destroy, :position]],
      questions_attributes: [:id, :kind, :body, :guidelines, :required, :_destroy, :position,
        question_options_attributes: [:id, :body, :_destroy]],
      user_ids: [])
  end

  def render_errors(default_stage)
    @errors = []

    default_stage.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end

  def create_interview_kit(template)
    if params[:application_id].present?
      @application = Application.find(params[:application_id]) if params[:application_id].present?
      @kit = Assessment.create(application_id: params[:application_id], 
        candidate: @application.candidate, name: template.title, preperation: template.preperation, kind: "interview") 
    elsif params[:candidate_id].present?
      @candidate = Candidate.find(params[:candidate_id]) if params[:candidate_id].present?
      @kit = Assessment.create(candidate: @candidate, 
        name: template.title, preperation: template.preperation, kind: "interview")
    end

    template.questions.each do |question| 
      @question = Question.create(question.attributes.except('id', 'interview_kit_template_id'))
      @question.update_attributes(assessment_id: @kit.id)

      question.question_options.each do |option|
        QuestionOption.create(question_id: @question.id, body: option.body)
      end
    end

    @scorecard = Scorecard.create(assessment: @kit)

    if template.scorecard.present?  
      template.scorecard.section_options.each do |option| 
        SectionOption.create(scorecard_id: @scorecard.id, body: option.body)
      end
    end
  end

  def create_scorecard(template)
    if params[:application_id].present?
      @application = Application.find(params[:application_id])
      @kit = Assessment.create(application_id: params[:application_id], 
        candidate: @application.candidate, name: template.name, kind: "scorecard") 

    elsif params[:candidate_id].present?
      @candidate = Candidate.find(params[:candidate_id]) if params[:candidate_id].present?

      @kit = Assessment.create(candidate: @candidate, name: template.name, kind: "interview") 
    end

    @scorecard = Scorecard.create(assessment: @kit)

    template.section_options.each do |option| 
      SectionOption.create(scorecard_id: @scorecard.id, body: option.body)
    end
  end
end