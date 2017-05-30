xml.instruct!(:xml, :version=> "1.0", :encoding => "UTF-8")
xml.source do 
xml.publisher "TalentWiz"
xml.publisherurl "https://www.talentwiz.ca"
  xml.jobs do
    @jobs.each do |job|
      if job.status == 'open'
        xml.job do
          xml.id { xml.cdata!((job.id).to_s) }
          xml.jobref { xml.cdata!((job.id).to_s) }
          xml.company { xml.cdata! (job.company.name)}
          xml.joburl { xml.cdata!(job.url) }
          xml.title { xml.cdata!(job.title) }
          xml.description { xml.cdata!(job.description) }
          xml.jobaddress {xml.cdata!(job.address)}
          xml.occupationcategory { xml.cdata! (industries.first.name)}
          xml.location { xml.cdata!(job.location) }
          xml.country { xml.cdata! (job.country) }
          xml.jobcity { xml.cdata! (job.city) }
          xml.jobprovince { xml.cdata! (job.province) }
          xml.jobtype { xml.cdata! (job.kind)}
          xml.postdate {xml.cdata!((job.created_at).to_s)}
          xml.expiration_date {xml.cdata!((job.created_at).to_s)}
        end
      end
    end
  end
end