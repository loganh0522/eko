class Business::CandidatesController < ApplicationController
  layout "business"
  # filter_access_to :all
  # filter_access_to :filter_candidates, :require => :read
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index
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
      @candidates = Candidate.search(params[:qcv], where: where, fields: qcv_fields, match: :word_start, per_page: 10, page: params[:page])
    else
      @candidates = Candidate.search(query, where: where, fields: fields, match: :word_start, per_page: 10, page: params[:page])
    end

    @invitation = InterviewInvitation.new
    @tags = current_company.tags

    respond_to do |format|
      format.js
      format.html
    end  
  end

  def new
    if params[:job].present?
      @job = Job.find(params[:job])
    end
    
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
          Application.create(candidate: @candidate, job_id: @job.id, company_id: current_company)
          @candidates = current_company.candidates
        elsif params[:job_ids]
          @job = Job.find(params[:job_ids])
          Application.create(candidate: @candidate, job_id: @job.id, company_id: current_company)
          @candidates = Candidate.search("*", where: {jobs: {all: [@job.id]}}, per_page: 10)
        else
          @candidates = current_company.candidates
        end      
        add_tags(@candidate)
      else 
        render_errors(@candidate)
      end

      @tags = current_company.tags
      @tag = Tag.new
      format.js
    end
  end

  def show 
    @candidate = Candidate.find(params[:id])
    
    if @candidate.manually_created == true 
      @applicant = Candidate.find(params[:id])
    else 
      @applicant = @candidate.user.profile
    end
    
    respond_to do |format|
      format.html { 
        @candidates = current_company.candidates.where(id: params[:id])
        @tag = Tag.new
        @tags = current_company.tags
        render action: :index 
      }
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

  def destroy
    @candidate = Candidate.find(params[:id])
    @candidate.destroy 
    @candidates = current_company.candidates
    @tags = current_company.tags
    @tag = Tag.new
    
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
    
    @candidates = current_company.candidates
    @tags = current_company.tags
    @tag = Tag.new
    respond_to do |format|
      format.js
    end 
  end

  def autocomplete
    @candidates = Candidate.search(params[:term], where: {company_id: current_company.id}, fields: [{full_name: :word_start}]).to_a

    respond_to do |format|
      format.json { render json: @candidates.as_json(only: [:first_name, :id, :last_name, :full_name], methods: [:avatar_url])}
    end
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
      work_experiences_attributes: [:id, :body, :_destroy, :title, :company_name, :description, :start_month, :start_year, :end_month, :end_year, :current_position, :industry_ids, :function_ids, :location],
      educations_attributes: [:id, :school, :degree, :description, :start_month, :start_year, :end_month, :end_year, :_destroy], 
      resumes_attributes: [:id, :name, :_destroy],
      social_links_attributes: [:id, :url, :kind, :_destroy])
  end
end