class WidgetsController < ApplicationController
  layout nil
  session :off

  # before_filter :validate_api_key, :only => [:company_jobs]

  def company_jobs
    @company = Company.where(widget_key: params[:widget_key])
    @job_board = @company.job_board
    @jobs = @company.jobs
  end

end