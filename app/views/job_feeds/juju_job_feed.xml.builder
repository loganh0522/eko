xml.instruct!(:xml, :version=> "1.0", :encoding => "UTF-8")
xml.positionfeed do 
xml.source "TalentWiz"


xml.sourceurl "https://www.talentwiz.ca"
xml.feeddate {xml.cdata! (@jobs.last.title)}
  xml.jobs do
    @jobs.each do |job|
      xml.job do
        xml.id { xml.cdata!((job.id).to_s) }
        xml.employer { xml.cdata! (job.company.name)}
        xml.title { xml.cdata!(job.title) }
        xml.description { xml.cdata!(job.description) }
        xml.joburl { xml.cdata!(job.url) }       
        xml.postingdate {xml.cdata!((job.created_at).to_s)}
       
        xml.location do 
          xml.nation { xml.cdata! (job.country) }
          xml.city { xml.cdata! (job.city) }
          xml.state { xml.cdata! (job.province) }
          xml.zip { xml.cdata! (job.postal_code) }
        end

        xml.salary do 
          xml.period { xml.cdata! (job.min_salary)}
          xml.min { xml.cdata! (job.min_salary)}
          xml.max { xml.cdata! (job.max_salary)}
        end

        xml.experience do 
          xml.min { xml.cdata! (job.min_exp) }
          xml.max { xml.cdata! (job.max_exp) }
        end

        xml.jobtype { xml.cdata! (job.kind)}
        xml.education {xml.cdata! (job.education_level)} 
      end
    end
  end
end