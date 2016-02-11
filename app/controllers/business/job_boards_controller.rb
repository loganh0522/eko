class Business::JobBoardsController < ApplicationController 
  def index
    @jobs = current_company.jobs
  end

end