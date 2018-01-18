class JobFeedsController < ApplicationController 
  
  def neuvoo_job_feed
    @jobs = Job.where(status: "open", verified: true)
  end

  def adzuna_job_feed
    @jobs = Job.joins(:job_feed).where(status: "open", verified: true, :job_feeds => {:adzuna => true})
  end

  def ziprecruiter_job_feed
    @jobs = Job.joins(:job_feed).where(status: "open", :job_feeds => {:ziprecruiter => true})
    render 'job_feeds/adzuna_job_feed.xml.builder', formats: [:xml]
  end

  def eluta_job_feed
    @jobs = Job.joins(:job_feed).where(status: "open", :job_feeds => {:eluta => true})
  end

  def trovit_job_feed
    @jobs = Job.joins(:job_feed).where(status: "open", :job_feeds => {:trovit => true})
    render 'job_feeds/trovit_job_feed.xml.builder', formats: [:xml]
  end

  def job_inventory
    @jobs = Job.joins(:job_feed).where(status: "open", :job_feeds => {:jobinventory => true})
    render 'job_feeds/adzuna_job_feed.xml.builder', formats: [:xml]
  end

  def jooble_job_feed
    @jobs = Job.joins(:job_feed).where(status: "open", :job_feeds => {:jooble => true})

  end

  def jobrapido
    @jobs = Job.joins(:job_feed).where(status: "open", :job_feeds => {:jobrapido => true})
    render 'job_feeds/adzuna_job_feed.xml.builder', formats: [:xml]
  end
end