class Business::RatingsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def create
    @application = Application.find(params[:application_id])
    
    if @application.current_user_rating_present?(current_user)
      @rating = Rating.where(application_id: params[:application_id].to_i, 
        user_id: current_user.id).first
      @rating.update(score: params[:rating].to_f)
    else
      @rating = Rating.create(score: params[:rating].to_f, 
        application_id: params[:application_id].to_i, 
        user_id: current_user.id)
    end
  end

  private 

  def rating_params
    params.require(:rating).permit(:application_id, :score)
  end
end