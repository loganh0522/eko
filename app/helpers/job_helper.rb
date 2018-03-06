module JobHelper
  def applied_applications_count
    @job.applications.count
  end

  def rejected_applications_count
    @job.applications.where(rejected: true).count
  end

  def hired_applications_count
    @job.applications.where(hired: true).count
  end

  def application_stage(candidate, job)
    application = Application.where(candidate: candidate, job: job).first

    if application.rejected == true
      ("Rejected").to_s
    elsif  application.stage.present?
      application.stage.name
    else 
      ("Applied").to_s
    end
  end

  def current_application(candidate, job)
    Application.where(candidate: candidate, job: job).first
  end
end