xml.instruct!(:xml, :version=> "1.0", :encoding => "UTF-8")
xml.source do 
xml.source "TalentWiz"
xml.sourceurl "https://www.talentwiz.ca"
  xml.jobs do
    @jobs.each do |job|
      if job.status == 'open'
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
            xml.country { xml.cdata! (job.country) }
          end

          xml.jobtype { xml.cdata! (job.kind)}
          xml.education {xml.cdata! (job.education_level)} 
        end
      end
    end
  end
end