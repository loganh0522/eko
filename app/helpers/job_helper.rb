module JobHelper
  def applied_applications_count
    @job.applications.count
  end

  def rejected_applications_count
    @job.applications.where(rejected: true).count
  end

  def application_stage(application)
    if application.rejected == true
      ("Rejected").to_s
    elsif  application.stage.present?
      application.stage.name
    else 
      ("Applied").to_s
    end
  end

end