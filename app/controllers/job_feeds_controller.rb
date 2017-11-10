class JobFeedsController < ApplicationController 

  def adzuna
    @jobs = Job.joins(:job_feed).where(status: "open", :job_feeds => {:adzuna => true})
  end

  def ziprecruiter 
    @jobs = Job.joins(:job_feed).where(status: "open", :job_feeds => {:ziprecruiter => true})
  end

  def eluta
    @jobs = Job.joins(:job_feed).where(status: "open", :job_feeds => {:eluta => true})
  end

  def trovit
    @jobs = Job.joins(:job_feed).where(status: "open", :job_feeds => {:trovit => true})
  end

  def job_inventory
    @jobs = Job.joins(:job_feed).where(status: "open", :job_feeds => {:jobinventory => true})
  end

  def jooble
    @jobs = Job.joins(:job_feed).where(status: "open", :job_feeds => {:juju => true})
  end

  def rai
    @jobs = Job.joins(:job_feed).where(status: "open", :job_feeds => {:jobrapido => true})
  end



end