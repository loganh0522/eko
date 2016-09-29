class WidgetsController < ApplicationController
  layout nil

  # before_filter :validate_api_key, :only => [:company_jobs]

  protect_from_forgery except: :company_jobs

  def company_jobs
    @company = Company.where(widget_key: params[:widget_key])
    @job_board = @company.first.job_board
    @jobs = @company.first.jobs
  end

  # protected 

  # def validate_api_key 

  # end
end