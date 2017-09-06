class Business::CandidatesController < ApplicationController
  # filter_access_to :all
  # filter_access_to :filter_candidates, :require => :read
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index
    if params[:term].present?
      @candidates = current_company.candidates.order(:full_name).where("full_name ILIKE ?", "%#{params[:term]}%")
      render :json => @candidates.to_json 
    else
      where = {}
      fields = [:work_titles, :work_description, :work_company, :education_description, :education_school]
      query = params[:query].nil? || "*"
      where[:company_id] = current_company.id 
      where[:job_title] = {all: params[:job_title]} if params[:job_title].present?
      where[:jobs] = {all: params[:jobs]} if params[:jobs].present?
      where[:job_status] = params[:status] if params[:status].present?
      where[:job_location] = {all: params[:location]} if params[:location].present?
      where[:tags] = {all: params[:tags]} if params[:tags].present?
      where[:created_at] = {gte: params[:date_applied].to_time, lte: Time.now} if params[:date_applied].present?
      if params[:qcv].present?
        @candidates = Candidate.search(params[:qcv], where: where, fields: fields, match: :word_start).to_a
      else
        @candidates = Candidate.search("*", where: where).to_a
      end
    end

    @tags = current_company.tags
    @tag = Tag.new
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
          @applications = @job.applications
        else
          @candidates = current_company.candidates
        end      
        create_application(@candidate)  
        add_tags(@candidate)
      else 
        render_errors(@candidate)
      end
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

  def destroy
    @candidate = Candidate.find(params[:id])
    @candidate.destroy 
    @candidates = current_company.candidates

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

    respond_to do |format|
      format.js
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

  def create_application(candidate)  
    if params[:jobs_ids].present?
      @ids = params[:jobs_ids].split(',')
      @ids.each do |id|
        Application.create(candidate: candidate, job_id: id, company_id: current_company)
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
    params.require(:candidate).permit(:first_name, :last_name, :email, :phone, :location, :company_id, :manually_created, 
      work_experiences_attributes: [:id, :body, :_destroy, :title, :company_name, :description, :start_month, :start_year, :end_month, :end_year, :current_position, :industry_ids, :function_ids, :location],
      educations_attributes: [:id, :school, :degree, :description, :start_month, :start_year, :end_month, :end_year, :_destroy], 
      resumes_attributes: [:id, :name, :_destroy],
      social_links_attributes: [:id, :url, :kind, :_destroy])
  end
end