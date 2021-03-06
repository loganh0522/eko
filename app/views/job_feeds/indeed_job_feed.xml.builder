xml.instruct!(:xml, :version=> "1.0", :encoding => "UTF-8")
xml.source do 
xml.publisher "TalentWiz"
xml.publisherurl "https://www.talentwiz.ca"
xml.lastBuildDate ""
  @jobs.each do |job|
    xml.job do
      xml.title { xml.cdata!(job.title) }
      xml.description { xml.cdata!(job.description) } 
      xml.date {xml.cdata!((job.created_at).to_s)}
      xml.referencenumber { xml.cdata!((job.id).to_s) }
      xml.url { xml.cdata!(job.url) }
      xml.company { xml.cdata! (job.company.name)}
      xml.sourcename "TalentWiz"
      xml.city { xml.cdata! (job.city) } if job.city.present?
      xml.state { xml.cdata! (job.province) } if job.province.present?
      xml.country { xml.cdata! (job.country) } if job.country.present?
      xml.postalcode {xml.cdata! (job.postal_code)} if job.postal_code.present?    
      xml.salary { xml.cdata!(job.salary) } if job.start_salary.present?
      xml.category {xml.cdata! (job.industry)} if job.industry.present?
      xml.jobtype {xml.cdata! (job.kind)} if job.kind.present?
      xml.education {xml.cdata! (job.education_level)} if job.education_level.present?
      xml.sponsored {xml.cdata! (job.job_feed.indeed_boost)} if job.job_feed.indeed_boost.present?
      xml.budget {xml.cdata! (job.job_feed.indeed_budget)} if job.job_feed.indeed_budget.present?

      xml.indeed_apply_data do
        jobTitle = "indeed-apply-jobTitle=" + URI.encode(job.title) + "&"
        jobId = "indeed-apply-jobId=#{job.id}" + "&"
        jobCompanyName = "indeed-apply-apiCompanyName=" + URI.encode(job.company.name) + "&"
        apiToken = "indeed-apply-apiToken=" + ENV['INDEED_TOKEN'] + "&"
        name = "indeed-apply-jobname=firstlastname"
        postUrl = "indeed-apply-postUrl=" + URI.encode('https://www.talentwiz.ca/inbound-can/indeed-apply', ": /")  
        questions = "indeed-apply-questions" + URI.encode("https://www.talentwiz.ca/jobs/#{job.id}/questions", ": /") 
        
        data = jobTitle + jobId + jobCompanyName + name + apiToken + postUrl + questions
        xml.cdata! (data)
      end
    end
  end
end
