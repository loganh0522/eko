xml.instruct!(:xml, :version=> "1.0", :encoding => "UTF-8")
xml.source do 
xml.publisher "TalentWiz"
xml.publisherurl "https://www.talentwiz.ca"
  xml.jobs do
    @jobs.each do |job|
      xml.job do
        xml.name { xml.cdata!(job.title) }
        xml.url { xml.cdata!(job.url) } 
        xml.region { xml.cdata!(job.city) }
        xml.country { xml.cdata! (job.country) }
        xml.company { xml.cdata! (job.company.name)} 
        xml.description { xml.cdata!(job.description) }
        xml.id { xml.cdata!((job.id).to_s) }
        

        if job.questions.present?
          xml.apply_url { xml.cdata!(job.url + '/apply') } 
        end

        
        xml.jobtype { xml.cdata!(job.kind) }
        xml.salary { xml.cdata!(job.start_salary) } if job.start_salary.present?



        xml.pubdate {xml.cdata!((job.created_at).to_s)}
        xml.updated {xml.cdata!((job.updated_at).to_s)}
        xml.expire {xml.cdata!((job.updated_at).to_s)}
      end
    end
  end
end