class Business::CandidatesController < ApplicationController
  layout "business"
  load_and_authorize_resource only: [:new, :create, :edit, :update, :index, :show, :destroy]
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index    
    @candidates = current_company.candidates.paginate(page: params[:page], per_page: 10).accessible_by(current_ability)
    @tags = current_company.tags
  end

  def new
    @job = Job.find(params[:job]) if params[:job].present?
    @candidate = Candidate.new

    respond_to do |format|
      format.js
    end
  end

  def create 
    @candidate = Candidate.new(candidate_params)
    
    respond_to do |format| 
      if @candidate.save
        if params[:job_id].present? 
          @job = Job.find(params[:job_id])
          Application.create(candidate: @candidate, job_id: @job.id, company_id: current_company.id)
          @candidates = @job.candidates.paginate(page: params[:page], per_page: 10)
        else
          @candidates = current_company.candidates.paginate(page: params[:page], per_page: 10)
        end 
        add_tags(@candidate)
      else 
        render_errors(@candidate)
      end
      @tags = current_company.tags
      format.js
    end
  end

  def show 
    @candidate = Candidate.find(params[:id])
    @tag = Tag.new
    
    if @candidate.manually_created == true 
      @applicant = Candidate.find(params[:id])
    else 
      @applicant = @candidate.user
    end
    
    respond_to do |format|
      format.html 
      format.js
    end  
  end

  def edit
    @candidate = Candidate.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @candidate = Candidate.find(params[:id])

    respond_to do |format| 
      if @candidate.update(candidate_params)
        format.js
      else
        render_errors(@candidate)
        format.js
      end
    end
  end

  def show_project
    @project = Project.find(params[:project])

    respond_to do |format| 
      format.js
    end
  end

  def destroy
    @candidate = Candidate.find(params[:id])
    @candidate.destroy 


    respond_to do |format|
      format.js
    end
  end

  def confirm_destroy
    respond_to do |format|
      format.js
    end 
  end

  def destroy_multiple
    @ids = params[:applicant_ids].split(',')

    @ids.each do |id| 
      candidate = Candidate.find(id)
      candidate.destroy
    end
    
    @candidates = current_company.candidates.paginate(page: params[:page], per_page: 10)
    @tags = current_company.tags
    
    respond_to do |format|
      format.js
    end
  end

  def autocomplete
    if params[:term] == ''
      term = "*"
    else 
      term = params[:term]
    end
    @candidates = Candidate.search(term, where: {company_id: current_company.id}, fields: [{full_name: :word_start}]).to_a

    respond_to do |format|
      format.js {@candidates}
    end
  end

  def search 
    where = {}
    qcv_fields = [:work_titles, :work_description, :work_company, :education_description, :education_school]
    fields = [:first_name, :last_name, :full_name, :email]
    
    if params[:query].present?
      query = params[:query] 
    else
      query = "*"
    end

    where[:company_id] = current_company.id 
    where[:rating] = params[:rating] if params[:rating].present?
    where[:job_title] = {all: params[:job_title]} if params[:job_title].present?
    where[:jobs] = {all: params[:jobs]} if params[:jobs].present?
    where[:job_status] = params[:status] if params[:status].present?
    where[:job_location] = params[:location] if params[:location].present?
    where[:tags] = {all: params[:tags]} if params[:tags].present?
    where[:created_at] = {gte: params[:date_applied].to_time, lte: Time.now} if params[:date_applied].present?

    if params[:qcv].present? 
      @candidates = Candidate.search(params[:qcv], where: where, fields: qcv_fields, match: :word_start).records.paginate(page: params[:page], per_page: 10).accessible_by(current_ability)
    else
      @candidates = Candidate.search(query, where: where, fields: fields, match: :word_start).records.paginate(page: params[:page], per_page: 10).accessible_by(current_ability)
    end

    respond_to do |format|
      format.js
    end
  end

  def scorecards
    @candidate = Candidate.find(params[:id])
    @assessments = @candidate.assessments

  end

  private
  
  def add_tags(candidate)  
    if params[:tags].present?
      @tags = params[:tags].split(',')
      @company_tags = current_company.tags 
      @tags.each do |tag| 
        @tag = Tag.where(name: (tag.titleize), company_id: current_company.id).first    
        if @company_tags.include?(@tag)
          Tagging.create(candidate_id: candidate.id, tag_id: @tag.id)
        else
          @tag = Tag.create(name: tag, company: current_company)
          if @tag.save 
            Tagging.create(candidate_id: candidate.id, tag_id: @tag.id)
          end
        end 
      end
    end
  end

  def render_errors(candidate)
    @errors = []
    candidate.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end

  def candidate_params
    params.require(:candidate).permit(:first_name, :last_name, :email, :phone, :location, :company_id, :manually_created, :job_id,
      work_experiences_attributes: [:id, :body, :_destroy, :title, :company_name, :description, :start_month, :start_year, :end_month, :end_year, :current_position, :industry, :function, :location],
      educations_attributes: [:id, :school, :degree, :description, :start_month, :start_year, :end_month, :end_year, :_destroy], 
      resumes_attributes: [:id, :name, :_destroy],
      social_links_attributes: [:id, :url, :kind, :_destroy])
  end
end