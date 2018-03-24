class JobFeedsController < ApplicationController 
  
  def neuvoo_job_feed
    @jobs = Job.where(status: "open", is_active: true, verified: true)
    render 'job_feeds/neuvoo_job_feed.xml.builder', formats: [:xml]
  end

  def adzuna_job_feed
    @jobs = Job.joins(:job_feed).where(status: "open", verified: true, :job_feeds => {:adzuna => true})
    render 'job_feeds/adzuna_job_feed.xml.builder', formats: [:xml]
  end

  def ziprecruiter_job_feed
    @jobs = Job.joins(:job_feed).where(status: "open", is_active: true, verified: true, :job_feeds => {:ziprecruiter => true})
    render 'job_feeds/ziprecruiter_job_feed.xml.builder', formats: [:xml]
  end

  def eluta_job_feed
    @companies = Company.all
    render 'job_feeds/eluta_job_feed.xml.builder', formats: [:xml]
  end

  def trovit_job_feed
    @jobs = Job.joins(:job_feed).where(status: "open", is_active: true, verified: true, :job_feeds => {:trovit => true})
    render 'job_feeds/trovit_job_feed.xml.builder', formats: [:xml]
  end

  def job_inventory_feed
    @jobs = Job.joins(:job_feed).where(status: "open", is_active: true, verified: true, :job_feeds => {:jobinventory => true})
    render 'job_feeds/job_inventory_feed.xml.builder', formats: [:xml]
  end

  def jooble_job_feed
    @jobs = Job.joins(:job_feed).where(status: "open", is_active: true, verified: true, :job_feeds => {:jooble => true})
    render 'job_feeds/jooble_job_feed.xml.builder', formats: [:xml]
  end

  def indeed_job_feed
    @jobs = Job.joins(:job_feed).where(status: "open", verified: true, :job_feeds => {:indeed => true})
    render 'job_feeds/indeed_job_feed.xml.builder', formats: [:xml]
  end

  def juju_job_feed
    @jobs = Job.joins(:job_feed).where(status: "open", verified: true, :job_feeds => {:indeed => true})
    render 'job_feeds/juju_job_feed.xml.builder', formats: [:xml]
  end

  def jobrapido
    @jobs = Job.joins(:job_feed).where(status: "open", :job_feeds => {:jobrapido => true})
    render 'job_feeds/juju_job_feed.xml.builder', formats: [:xml]
  end
end