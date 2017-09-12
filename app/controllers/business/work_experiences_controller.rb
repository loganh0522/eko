class Business::WorkExperiencesController < ApplicationController
  layout "business"
  # filter_access_to :all
  # filter_access_to :filter_candidates, :require => :read

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

end