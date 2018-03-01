xml.instruct!(:xml, :version=> "1.0", :encoding => "UTF-8")
xml.source do 
xml.publisher "TalentWiz"
xml.lastBuildDate ""
xml.publisherurl "https://www.talentwiz.ca"
  xml.listing do
    @jobs.each do |job|
      xml.entry do
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
        xml.postalcode {xml.cdata! (job.postalcode)} if job.postalcode.present?    
        xml.salary { xml.cdata!(job.salary) } if job.start_salary.present?
        xml.category {xml.cdata! (job.industry)} if job.industry.present?
        xml.jobtype {xml.cdata! (job.kind)} if job.kind.present?
        xml.education {xml.cdata! (job.education_level)} if job.education_level.present?
        xml.sponsored {xml.cdata! (job.job_feed.indeed_sponsored)} if job.indeed_sponsored.present?
        xml.budget {xml.cdata! (job.job_feed.indeed_budget)} if job.indeed_budget.present?


        xml.indeed_apply_data do
          URL.encode(job.title)
          title = "indeed-apply-jobTitle=" + URI.encode(job.title) + "&"
          name = "indeed-apply-jobname=firstlastname"
          
          companyName = "indeed-apply-apiCompanyName=" + URI.encode(job.company.name) + "&"
          apiToken = "indeed-apply-apiToken=" + ENV['INDEED_TOKEN'] + "&"

          jobId = "indeed-apply-resume=required"
          jobId = "indeed-apply-jobTitle=#{job.id}"

          xml.cdata!
        end
      end
    end
  end
end
