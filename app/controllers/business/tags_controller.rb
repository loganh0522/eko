class Business::TagsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index
    @tags = Tag.order(:name).where("name ILIKE ?", "%#{params[:term]}%") 
    render :json => @tags.to_json 
  end

  def new
    @job = Job.find(params[:job_id])
    @application = Application.find(params[:application_id])
    @tag = Tag.new
  end

  def create
    binding.pry
    @tag = Tag.new(tag_params)
    @application = Application.find(params[:application_id])
    @tags = @application.tags
    if @tag.save 
      Tagging.create(application_id: params[:application_id], tag_id: @tag.id)
      respond_to do |format| 
        format.js 
      end
    end
  end

  def destroy
    @tag = Taggings.find(params[:id])
    @job = Job.find(params[:job_id])
    @tag.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end