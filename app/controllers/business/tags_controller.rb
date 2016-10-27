class Business::TagsController < ApplicationController
  
  def new
    @job = Job.find(params[:job_id])
    @application = Application.find(params[:application_id])
    @tag = Tag.new
  end

  def create
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

  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end