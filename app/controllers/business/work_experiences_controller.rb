class Business::WorkExperiencesController < ApplicationController
  layout "business"

  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def new
    @experience = WorkExperience.new
    @candidate = Candidate.find(params[:candidate_id])

    respond_to do |format| 
      format.js
    end
  end

  def create
    @experience = WorkExperience.new(exp_params)

    respond_to do |format| 
      if @experience.save
        format.js
      else
        render_errors(@experience)
      end
    end
  end

  def edit 
    @experience = WorkExperience.find(params[:id])

    respond_to do |format| 
      format.js
    end
  end

  def update
    @experience = WorkExperience.find(params[:id])

    respond_to do |format| 
      if @experience.update(exp_params)
        format.js
      else
        render_errors(@experience)
        format.js
      end
      
    end
  end

  def destroy
    @experience = WorkExperience.find(params[:id])
    @experience.destroy
    respond_to do |format| 
      format.js
    end
  end

  private

  def render_errors(comment)
    @errors = []
    comment.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end

  def user_params
    params.require(:user).permit(:user_id, :title, :company_name, :description, 
      :start_month, :start_year, :end_month, :end_year, :current_position, 
      :industry, :function, :location)
  end
end