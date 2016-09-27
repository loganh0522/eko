class SkillsController < ApplicationController 
  def index
    @skills = Skill.order(:name).where("name ILIKE ?", "%#{params[:term]}%")
    render :json => @skills.to_json 
  end
end