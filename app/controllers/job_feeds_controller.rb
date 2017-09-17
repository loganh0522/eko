class JobFeedsController < ApplicationController 

  def adzuna
    @jobs = Job.joins(:job_feed).where(:job_feeds => {:adzuna => true})
  end

  def ziprecruiter 
    @jobs = Job.joins(:job_feed).where(:job_feeds => {:ziprecruiter => true})
  end

  def eluta
    @jobs = Job.joins(:job_feed).where(:job_feeds => {:eluta => true})
  end



end