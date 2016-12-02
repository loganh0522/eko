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
    respond_to do |format|    
      @tag = Tag.where(name: params[:tag][:name], company_id: current_company.id) 
      @job = Job.find(params[:tag][:job_id])  
      @application = Application.find(params[:tag][:application_id])
      @tags = @application.tags

      if @tag.present?
        @tagging_present = false
        if @application.taggings.count != 0
          @application.taggings.each do |tagging|  
            if tagging.tag_id == @tag.first.id
              return
            else
              @tagging_present = true
              break
            end
          end
          if @tagging_present == false
            Tagging.create(application_id: params[:tag][:application_id], tag_id: @tag.first.id)
          end
        else
          Tagging.create(application_id: params[:tag][:application_id], tag_id: @tag.first.id)
        end
      else
        @tag = Tag.new(tag_params)
        @tag.company = current_company   
        if @tag.save 
          Tagging.create(application_id: params[:tag][:application_id], tag_id: @tag.id)
        end
      end

      format.js 
    end  
  end

  def destroy
    @tag = Tagging.find(params[:id])
    @job = Job.find(params[:job_id])
    @tag.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def tag_exists
     
  end

  def tag_params
    params.require(:tag).permit(:name, :company_id)
  end
end