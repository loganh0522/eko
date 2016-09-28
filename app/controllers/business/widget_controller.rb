class Business::WidgetController < ApplicationController
  layout nil

  def company_jobs
    @company = Company.where(name: params[:company_name])
    @jobs = Job.where(:company, @company)
  end

  private

  def validate_company
    return render(:text => 'Invalid API key.') if not @company = Company.where(:name, params[:comapany_name])
  end

  end

end