class Business::TagsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index
    @tags = current_company.tags.order(:name).where("name ILIKE ?", "%#{params[:term]}%") 
    render :json => @tags.to_json 
  end

  def new
    @job = Job.find(params[:job_id])
    @application = Application.find(params[:application_id])
    @tag = Tag.new

    respond_to do |format|
      format.js 
    end
  end

  def create 
    @company_tags = current_company.tags 
    @job = Job.find(params[:tag][:job_id]) 
    
    if params[:applicant_ids].present?
      @tag = Tag.find(params[:tag_id]) if params[:tag_id].present?
      applicant_ids = params[:applicant_ids].split(',')
      
      applicant_ids.each do |id| 
        if @company_tags.include?(@tag)
          Tagging.create(application_id: id, tag_id: @tag.id)
        else
          @tag = Tag.new(tag_params)
          @tag.company = current_company   
          if @tag.save 
            Tagging.create(application_id: id, tag_id: @tag.id)
          end
        end
      end
    else
      @application = Application.find(params[:tag][:application_id])
      @tag = Tag.where(name: params[:tag][:name], company_id: current_company.id).first
      
      if @company_tags.include?(@tag)
        Tagging.create(application_id: params[:tag][:application_id], tag_id: @tag.id)
      else
        @tag = Tag.new(tag_params)
        @tag.company = current_company   
        if @tag.save 
          Tagging.create(application_id: params[:tag][:application_id], tag_id: @tag.id)
        end
      end 
    end

    respond_to do |format|
      format.js
    end 
  end

  def destroy
    @tagging = Tagging.where(application_id: params[:application_id], tag_id: params[:id]).first
    @job = Job.find(params[:job_id])

    @tag = Tag.find(params[:id])
    @tagging.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :company_id)
  end
end