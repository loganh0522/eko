class Business::RatingsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def create
    @rating = Rating.create(score: params[:rating].to_f, 
      application_id: params[:application_id].to_i, 
      user_id: current_user.id)
  end

  def update
  end

  private 

  def rating_params
    params.require(:rating).permit(:application_id, :score)
  end
end