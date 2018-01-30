xml.instruct!(:xml, :version=> "1.0", :encoding => "UTF-8")


xml.source do 
xml.publisher "TalentWiz"

@companies.each do |company| 
  if company.jobs.joins(:job_feed).where(status: "open", is_active: true, verified: true, :job_feeds => {:eluta => true}).count > 0
    xml.employer do 
      xml.name { xml.cdata!((company.name).to_s) }
        xml.jobs do
          company.jobs.joins(:job_feed).where(status: "open", is_active: true, verified: true, :job_feeds => {:eluta => true}).each do |job|
            xml.job do
              xml.title { xml.cdata!(job.title) }
              xml.jobref { xml.cdata!((job.id).to_s) }
              xml.joburl { xml.cdata!(job.url) }  
              xml.description { xml.cdata!(job.description) }

              xml.occupationcategory { xml.cdata! (job.industry)} if job.industry.present?
              xml.jobaddress {xml.cdata!(job.address)} if job.address.present?
              xml.jobcity { xml.cdata! (job.city) } if job.city.present?
              xml.jobprovince { xml.cdata! (job.province) } if job.province.present?
              xml.jobtype { xml.cdata! (job.kind)} if job.kind.present?
              xml.salarymin { xml.cdata! (job.start_salary)} if job.start_salary.present?
              xml.salarymin { xml.cdata! (job.end_salary)} if job.end_salary.present?

              xml.postdate {xml.cdata!((job.created_at).to_s)}
            end
          end
        end
      end
    end
  end
end