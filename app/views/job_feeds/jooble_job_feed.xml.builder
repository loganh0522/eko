xml.instruct!(:xml, :version=> "1.0", :encoding => "UTF-8")
xml.source do 
xml.publisher "TalentWiz"
xml.publisherurl "https://www.talentwiz.ca"
  xml.jobs do
    @jobs.each do |job|
      if job.status == 'open'
        xml.job do
          xml.id { xml.cdata!((job.id).to_s) }
          xml.link { xml.cdata!(job.url) } 
          xml.company { xml.cdata! (job.company.name)}       
          xml.name { xml.cdata!(job.title) }
          xml.description { xml.cdata!(job.description) }
          xml.region { xml.cdata!(job.city) }
          xml.country { xml.cdata! (job.country) }
          xml.pubdate {xml.cdata!((job.created_at).to_s)}
          xml.update {xml.cdata!((job.updated_at).to_s)}
          xml.jobtype { xml.cdata! (job.kind)}
          xml.salary {xml.cdata! (job.salary)}
        end
      end
    end
  end
end