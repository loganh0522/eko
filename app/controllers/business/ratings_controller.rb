class Business::RatingsController < ApplicationController
  layout "business"
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def create
    @candidate = Candidate.find(params[:candidate_id])
 
    if @candidate.current_user_rating_present?(current_user)
      @rating = Rating.where(candidate_id: params[:candidate_id].to_i, 
        user_id: current_user.id).first
      @rating.update(score: params[:rating].to_f)
    else
      @rating = Rating.create(score: params[:rating].to_f, 
        candidate_id: params[:candidate_id].to_i, 
        user_id: current_user.id)
    end
    
    head 200 
  end

  private 

  def rating_params
    params.require(:rating).permit(:application_id, :score)
  end
end